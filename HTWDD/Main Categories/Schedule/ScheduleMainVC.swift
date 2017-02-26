//
//  ScheduleMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ScheduleMainVC: CollectionViewController {

    init() {
        let layout = TimetableCollectionViewLayout()
        super.init(layout: layout)
        self.collectionView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var lectures = [Day: [Lecture]]() {
        didSet {
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        Lecture.get(year: "2016", major: "044", group: "71-IK")
            .map(Lecture.groupByDay)
            .subscribe(onNext: { [weak self] lectures in
            self?.lectures = lectures
//            dump(lectures)

        }, onError: { err in

            print(err)
        })
        .addDisposableTo(self.rx_disposeBag)
    }

}

extension ScheduleMainVC: UICollectionViewDataSource {

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

extension ScheduleMainVC: TimetableCollectionViewLayoutDataSource {

    func itemMargin() -> CGFloat {
        return 2
    }

    func widthPerDay() -> CGFloat {
        let numberOfDays = UIDevice.current.orientation == .portrait ? 3 : 7
        return self.view.bounds.width / CGFloat(numberOfDays)
    }

    func startHour() -> CGFloat {
        return 6
    }

    func endHour() -> CGFloat {
        return 19
    }

    func dateComponentsForItem(at indexPath: IndexPath) -> (begin: DateComponents, end: DateComponents)? {
        guard let day = Day(rawValue: indexPath.section) else {
            return nil
        }
        guard let item = self.lectures[day]?[safe: indexPath.row] else {
            return nil
        }
        return (item.begin, item.end)
    }

}
