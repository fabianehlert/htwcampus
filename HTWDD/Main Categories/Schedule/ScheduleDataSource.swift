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

    private(set) var lectures = [Day: [Lecture]]() {
        didSet {
            self.data = calculate(input: self.lectures)
        }
    }

    private var data = [[Lecture]]() {
        didSet {
            self.invalidate()
        }
    }

    private let disposeBag = DisposeBag()

    var originDate: Date {
        didSet {
            self.data = calculate(input: self.lectures)
        }
    }
    var numberOfDays: Int

    init(originDate: Date, numberOfDays: Int) {
        self.originDate = originDate
        self.numberOfDays = numberOfDays
    }

    func load() {
        Lecture.get(year: "2016", major: "044", group: "71-IK")
            .map(Lecture.groupByDay)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] lectures in
                self?.lectures = lectures
                }, onError: { err in
                    print(err)
            })
            .addDisposableTo(self.disposeBag)
    }

    func lecture(at indexPath: IndexPath) -> Lecture? {
        return self.data[indexPath.section][indexPath.row]
    }

    private func calculate(input: [Day: [Lecture]]) -> [[Lecture]] {
        let sections = 0..<self.numberOfSections()
        let originDay = self.originDate.weekday
        let startWeek = self.originDate.weekNumber

        let a: [[Lecture]] = sections.map { section in
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
        return lecture(at: index)
    }

    override func numberOfSections() -> Int {
        return numberOfDays
    }

    override func numberOfItems(in section: Int) -> Int {
        return self.data[safe: section]?.count ?? 0
    }
}
