//
//  ScheduleDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 03/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

protocol ScheduleDataSourceDelegate: class {
    func scheduleDataSourceHasFinishedLoading()
    func scheduleDataSourceHasUpdated()
}

class ScheduleDataSource: CollectionViewDataSource {

    struct Configuration {
        let context: HasSchedule
        /// if nil -> start of semester will be taken
        var originDate: Date?
        /// if nil -> whole period of semester will be taken
        var numberOfDays: Int?
        var auth: ScheduleService.Auth?
        var shouldFilterEmptySections: Bool

        init(context: HasSchedule, originDate: Date, numberOfDays: Int, auth: ScheduleService.Auth?, shouldFilterEmptySections: Bool) {
            self.context = context
            self.originDate = originDate
            self.numberOfDays = numberOfDays
            self.auth = auth
            self.shouldFilterEmptySections = shouldFilterEmptySections
        }
    }

    var originDate: Date? {
        didSet {
            self.data = self.calculate()
        }
    }
    var numberOfDays: Int? {
        didSet {
            self.data = self.calculate()
        }
    }
    var auth: ScheduleService.Auth? {
        didSet {
            self.load()
        }
    }

    private let days = [
		Loca.monday,
		Loca.tuesday,
		Loca.wednesday,
		Loca.thursday,
		Loca.friday,
		Loca.saturday,
		Loca.sunday
	]

    private(set) var lectures = [Day: [Lecture]]()
    private var semesterInformations = [SemesterInformation]() {
        didSet {
            self.semesterInformation = SemesterInformation.information(date: Date(), input: self.semesterInformations)
        }
    }
    private var semesterInformation: SemesterInformation?

    struct Data {
        let day: Day
        let date: Date
        let lectures: [Lecture]
    }

    private var data = [Data]() {
        didSet {
            self.invalidate()
            self.delegate?.scheduleDataSourceHasUpdated()
        }
    }

    private let disposeBag = DisposeBag()
    private let service: ScheduleService
    private let filterEmptySections: Bool

    weak var delegate: ScheduleDataSourceDelegate?

    private(set) var indexPathOfToday: IndexPath?

    init(configuration: Configuration) {
        self.service = configuration.context.scheduleService
        self.originDate = configuration.originDate
        self.numberOfDays = configuration.numberOfDays
        self.auth = configuration.auth
        self.filterEmptySections = configuration.shouldFilterEmptySections
    }

	func load() {
        guard let auth = self.auth else {
            Log.info("Can't load schedule if no authentication is provided. Abort…")
            return
        }

		self.service.load(parameters: auth)
			.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] information in
				self?.lectures = information.lectures
				self?.semesterInformations = information.semesters
				self?.data = self?.calculate() ?? []
                self?.delegate?.scheduleDataSourceHasFinishedLoading()
			}).disposed(by: self.disposeBag)
	}

	func lecture(at indexPath: IndexPath) -> Lecture? {
        return self.data[indexPath.section].lectures[indexPath.row]
    }

    func dayName(indexPath: IndexPath) -> String {
        let index = self.data[indexPath.section].day.rawValue
        return self.days[index]
    }

    private func calculate() -> [Data] {
        guard let semesterInformation = self.semesterInformation, !self.lectures.isEmpty else {
            return []
        }

        let originDate = self.originDate ?? semesterInformation.period.begin.date

        let sections = 0..<(self.numberOfDays ?? self.semesterInformation?.period.lengthInDays ?? 0)
        let originDay = originDate.weekday
        let startWeek = originDate.weekNumber

        var all: [Data] = sections.map { section in
            let date = originDate.byAdding(days: TimeInterval(section))
            let day = date.weekday

            guard semesterInformation.lecturesContains(date: date) else {
                return Data(day: day, date: date, lectures: [])
            }

            guard !semesterInformation.freeDaysContains(date: date) else {
                return Data(day: day, date: date, lectures: [])
            }

            let weekNumber = originDay.weekNumber(starting: startWeek, addingDays: section)
            let l = (self.lectures[originDay.dayByAdding(days: section)] ?? []).filter { lecture in
                let weekEvenOddValidation = lecture.week.validate(weekNumber: weekNumber)
                let weekOnlyValidation = lecture.weeks?.contains(weekNumber) ?? true
                return weekEvenOddValidation && weekOnlyValidation
            }
            return Data(day: day, date: date, lectures: l)
        }
        if self.filterEmptySections {
            all = all.filter { !$0.lectures.isEmpty }
        }
        self.indexPathOfToday = all
            .index(where: { $0.date.sameDayAs(other: Date()) })
            .map({ IndexPath(item: 0, section: $0) })
        return all
    }

    // MARK: CollectionViewDataSource methods

    override func item(at index: IndexPath) -> Identifiable? {
        return self.lecture(at: index)
    }

    override func numberOfSections() -> Int {
        return self.data.count
    }

    override func numberOfItems(in section: Int) -> Int {
        return self.data[safe: section]?.lectures.count ?? 0
    }

}
