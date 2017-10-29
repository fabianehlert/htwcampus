//
//  ScheduleDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 03/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class ScheduleDataSource: CollectionViewDataSource {

    var originDate: Date {
        didSet {
            self.data = self.calculate()
        }
    }
    var numberOfDays: Int {
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
            self.semesterInformation = SemesterInformation.information(date: self.originDate, input: self.semesterInformations)
        }
    }
    private var semesterInformation: SemesterInformation?

    private var data = [[Lecture]]() {
        didSet {
            self.invalidate()
        }
    }

    private let disposeBag = DisposeBag()
    private let service: ScheduleService

    init(context: AppContext, originDate: Date, numberOfDays: Int, auth: ScheduleService.Auth?) {
        self.service = context.scheduleService
        self.originDate = originDate
        self.numberOfDays = numberOfDays
        self.auth = auth
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
			}).disposed(by: self.disposeBag)
	}

	func lecture(at indexPath: IndexPath) -> Lecture? {
        return self.data[indexPath.section][indexPath.row]
    }

    func dayName(indexPath: IndexPath) -> String {
        let index = (self.originDate.weekday.rawValue + indexPath.section) % self.days.count
        return self.days[index]
    }

    private func calculate() -> [[Lecture]] {
        guard let semesterInformation = self.semesterInformation, !self.lectures.isEmpty else {
            return []
        }

        let sections = 0..<self.numberOfSections()
        let originDay = self.originDate.weekday
        let startWeek = self.originDate.weekNumber

        let a: [[Lecture]] = sections.map { section in
            let date = self.originDate.byAdding(days: TimeInterval(section))

            guard semesterInformation.lecturesContains(date: date) else {
                return []
            }

            guard !semesterInformation.freeDaysContains(date: date) else {
                return []
            }

            let weekNumber = originDay.weekNumber(starting: startWeek, addingDays: section)
            return (self.lectures[originDay.dayByAdding(days: section)] ?? []).filter { lecture in
                let weekEvenOddValidation = lecture.week.validate(weekNumber: weekNumber)
                let weekOnlyValidation = lecture.weeks?.contains(weekNumber) ?? true
                return weekEvenOddValidation && weekOnlyValidation
            }
        }
        return a
    }

    // MARK: CollectionViewDataSource methods

    override func item(at index: IndexPath) -> Identifiable? {
        return self.lecture(at: index)
    }

    override func numberOfSections() -> Int {
        return self.numberOfDays
    }

    override func numberOfItems(in section: Int) -> Int {
        return self.data[safe: section]?.count ?? 0
    }
}
