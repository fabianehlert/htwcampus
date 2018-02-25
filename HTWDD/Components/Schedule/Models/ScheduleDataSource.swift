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
        var auth: ScheduleService.Auth?
        var shouldFilterEmptySections: Bool
        var addFreeDays: Bool
        var splitFreeDaysInDays: Bool

        init(context: HasSchedule, auth: ScheduleService.Auth?, shouldFilterEmptySections: Bool, addFreeDays: Bool, splitFreeDaysInDays: Bool) {
            self.context = context
            self.auth = auth
            self.shouldFilterEmptySections = shouldFilterEmptySections
            self.addFreeDays = addFreeDays
            self.splitFreeDaysInDays = splitFreeDaysInDays
        }
    }

    var auth: ScheduleService.Auth? {
        didSet {
            guard self.auth != nil else {
                self.data = []
                self.semesterInformation = nil
                self.semesterInformations = []
                self.lectures = [:]
                self.invalidate()
                return
            }
            self.load()
        }
    }

    private(set) var lectures = [Day: [AppLecture]]()
    private var semesterInformations = [SemesterInformation]() {
        didSet {
            self.semesterInformation = SemesterInformation.information(date: Date(), input: self.semesterInformations)
        }
    }
    private(set) var semesterInformation: SemesterInformation?

    struct Data {
        let day: Day
        let date: Date
        let lectures: [AppLecture]
        let freeDays: [Event]
    }

    private var data = [Data]() {
        didSet {
            self.delegate?.scheduleDataSourceHasUpdated()
        }
    }

    private let disposeBag = DisposeBag()
    private let service: ScheduleService
    private let filterEmptySections: Bool
    private let splitFreeDaysInDays: Bool

    weak var delegate: ScheduleDataSourceDelegate?

    private(set) var indexPathOfToday: IndexPath?

    private let loadingCount = Variable(0)
    
    lazy var loading = self.loadingCount
        .asObservable()
        .map({ $0 > 0 })
        .observeOn(MainScheduler.instance)
	
    init(configuration: Configuration) {
        self.service = configuration.context.scheduleService
        self.auth = configuration.auth
        self.filterEmptySections = configuration.shouldFilterEmptySections
        self.splitFreeDaysInDays = configuration.splitFreeDaysInDays
    }

	func load() {
        self.loadingCount.value += 1
        guard let auth = self.auth else {
            Log.info("Can't load schedule if no authentication is provided. Abort…")
			self.loadingCount.value -= 1
			return
        }

		self.service.load(parameters: auth)
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] information in
				self?.lectures = information.lectures
				self?.semesterInformations = information.semesters
                self?.invalidate()
				self?.delegate?.scheduleDataSourceHasFinishedLoading()
				self?.loadingCount.value -= 1
				}, onError: { [weak self] _ in
					self?.loadingCount.value -= 1
			}).disposed(by: self.disposeBag)
	}
    
    override func invalidate() {
        self.data = self.calculate()
        super.invalidate()
    }

	func lecture(at indexPath: IndexPath) -> AppLecture? {
        return self.data[safe: indexPath.section]?.lectures[safe: indexPath.row]
    }
    
    func freeDay(at indexPath: IndexPath) -> Event? {
        return self.data[safe: indexPath.section]?.freeDays[safe: indexPath.row]
    }

    func dayInformation(indexPath: IndexPath) -> (day: Day, date: Date) {
        let dataPart = self.data[indexPath.section]
        return (dataPart.day, dataPart.date)
    }

    private func calculate() -> [Data] {
        guard let semesterInformation = self.semesterInformation, !self.lectures.isEmpty else {
            return []
        }

        let originDate = semesterInformation.period.begin.date

        let sections = 0..<semesterInformation.period.lengthInDays
        let originDay = originDate.weekday
        let startWeek = originDate.weekNumber

        var all: [Data] = sections.map { section in
            let date = originDate.byAdding(days: TimeInterval(section))
            let day = date.weekday

            // Check if date of section exists in semester information
            guard semesterInformation.lecturesContains(date: date) else {
                // If not, check if date of section is today
                if date.sameDayAs(other: Date()) {
                    // If so, try to create a `Event` "Holiday" object
                    if let eventDate = EventDate(date: date) {
                        let freeDays = [Event(name: Loca.Schedule.holiday, period: EventPeriod(begin: eventDate, end: eventDate))]
                        return Data(day: day, date: date, lectures: [], freeDays: freeDays)
                    }
                }
                // Otherwise return an empty `Data` object
                return Data(day: day, date: date, lectures: [], freeDays: [])
            }

            // Check if `date` is marked as a free day
            if let freeDay = semesterInformation.freeDayContains(date: date) {
                if self.splitFreeDaysInDays {
                    return Data(day: day, date: date, lectures: [], freeDays: [freeDay])
                } else if freeDay.period.begin.date.sameDayAs(other: date) {
                    return Data(day: day, date: date, lectures: [], freeDays: [freeDay])
                } else {
                    return Data(day: day, date: date, lectures: [], freeDays: [])
                }
            }

            let weekNumber = originDay.weekNumber(starting: startWeek, addingDays: section)
            let l = (self.lectures[originDay.dayByAdding(days: section)] ?? []).filter { lecture in
                let weekEvenOddValidation = lecture.lecture.week.validate(weekNumber: weekNumber)
                let weekOnlyValidation = lecture.lecture.weeks?.contains(weekNumber) ?? true
                return weekEvenOddValidation && weekOnlyValidation
                }.sorted { l1, l2 in
                    return l1.lecture.begin < l2.lecture.begin
            }
            let freeDays: [Event]
            
            if l.isEmpty && date.sameDayAs(other: Date()) {
                if let eventDate = EventDate(date: Date()) {
                    freeDays = [Event(name: Loca.Schedule.freeDay, period: EventPeriod(begin: eventDate, end: eventDate))]
                } else {
                    freeDays = []
                }
            } else {
                freeDays = []
            }
            return Data(day: day, date: date, lectures: l.filter { !$0.hidden }, freeDays: freeDays)
        }
        if self.filterEmptySections {
            all = all.filter { $0.date.sameDayAs(other: Date()) || !$0.lectures.isEmpty || !$0.freeDays.isEmpty }
        }
        self.indexPathOfToday = all
            .index(where: { $0.date.sameDayAs(other: Date()) })
            .map({ IndexPath(item: 0, section: $0) })
				
        return all
    }

    // MARK: CollectionViewDataSource methods

    override func item(at index: IndexPath) -> Identifiable? {
        return self.lecture(at: index) ?? self.freeDay(at: index)
    }

    override func numberOfSections() -> Int {
        return self.data.count
    }

    override func numberOfItems(in section: Int) -> Int {
        return self.data[safe: section].map { max($0.lectures.count, $0.freeDays.count) } ?? 0
    }

}
