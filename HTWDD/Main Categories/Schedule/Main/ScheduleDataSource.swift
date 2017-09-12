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

    struct Auth {
        let year: String
        let major: String
        let group: String
    }

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
    var auth: Auth {
        didSet {
            self.data = self.calculate()
        }
    }

    private let days = [Loca.monday, Loca.tuesday, Loca.wednesday, Loca.thursday, Loca.friday, Loca.saturday, Loca.sunday]

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
    private let network = Network()

    init(originDate: Date, numberOfDays: Int, auth: Auth) {
        self.originDate = originDate
        self.numberOfDays = numberOfDays
        self.auth = auth
    }

    func load() {
        let lecturesObservable = Lecture.get(network: self.network, year: "2016", major: "044", group: "71")
            .map(Lecture.groupByDay)

        let informationObservable = SemesterInformation.get(network: self.network)

        Observable.combineLatest(lecturesObservable, informationObservable) { ($0, $1) }
                  .observeOn(MainScheduler.instance)
            .subscribe { [weak self] (event) in
                guard case let .next((lectures, information)) = event else {
                    return
                }

                self?.lectures = lectures
                self?.semesterInformations = information
                self?.data = self?.calculate() ?? []
        }.addDisposableTo(self.disposeBag)
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
