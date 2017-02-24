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
        layout.dataSource = self
        self.collectionView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var lectures = [Day: [Lecture]]() {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        Lecture.get(year: "2016", major: "044", group: "71-IK")
            .map(Lecture.groupByDay)
            .subscribe(onNext: { [weak self] lectures in
            self?.lectures = lectures
            dump(lectures)

        }, onError: { err in

            print(err)
        })
        .addDisposableTo(self.rx_disposeBag)
    }

}

extension ScheduleMainVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lectures.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.red
        return cell
    }

}

extension ScheduleMainVC: TimetableCollectionViewLayoutDataSource {

    func numberOfDays() -> Int {
        return 7
    }

    func widthPerDay() -> CGFloat {
        return self.view.bounds.width / 3
    }

}
