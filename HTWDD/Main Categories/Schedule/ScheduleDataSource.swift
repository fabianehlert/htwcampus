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
            self.invalidate()
        }
    }

    private let disposeBag = DisposeBag()

    var originDate: Date {
        didSet {
            self.invalidate()
        }
    }

    init(originDate: Date) {
        self.originDate = originDate
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
        let day = self.originDate.weekday.dayByAdding(days: indexPath.section)
        return self.lectures[day]?[safe: indexPath.row]
    }

    // MARK: CollectionViewDataSource methods

    override func item(at index: IndexPath) -> Identifiable? {
        return lecture(at: index)
    }

    override func numberOfSections() -> Int {
        return 10
    }

    override func numberOfItems(in section: Int) -> Int {
        let day = self.originDate.weekday.dayByAdding(days: section)
        return self.lectures[day]?.count ?? 0
    }
}
