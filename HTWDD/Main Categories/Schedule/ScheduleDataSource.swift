//
//  ScheduleDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 03/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class ScheduleDataSource: NSObject {

    private(set) var lectures = [Day: [Lecture]]() {
        didSet {
            self.invalidate()
        }
    }

    private let disposeBag = DisposeBag()

    weak var collectionView: UICollectionView? {
        didSet {
            self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            self.collectionView?.dataSource = self
        }
    }

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

    func invalidate() {
        self.collectionView?.reloadData()
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }

    func lecture(at indexPath: IndexPath) -> Lecture? {
        guard let day = Day(rawValue: indexPath.section) else {
            return nil
        }
        return self.lectures[day]?[safe: indexPath.row]
    }

}

extension ScheduleDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let day = Day(rawValue: section) else {
            return 0
        }
        return self.lectures[day]?.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.lectures.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.red
        cell.contentView.layer.cornerRadius = 5
        return cell
    }

}
