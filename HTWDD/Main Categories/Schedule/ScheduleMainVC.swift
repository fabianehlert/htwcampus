//
//  ScheduleMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class ScheduleMainVC: CollectionViewController {

    let dataSource: ScheduleDataSource

    init() {
        let semesterStart = Date.from(day: 20, month: 03, year: 2017)!
        self.dataSource = ScheduleDataSource(originDate: semesterStart)
        super.init(layout: TimetableCollectionViewLayout())
        self.dataSource.collectionView = self.collectionView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource.load()
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

    func height() -> CGFloat {
        return self.collectionView.bounds.height - (self.navigationController?.navigationBar.bounds.height ?? 0)
    }

    func startHour() -> CGFloat {
        return 6
    }

    func endHour() -> CGFloat {
        return 19
    }

    func dateComponentsForItem(at indexPath: IndexPath) -> (begin: DateComponents, end: DateComponents)? {
        guard let item = self.dataSource.lecture(at: indexPath) else {
            return nil
        }
        return (item.begin, item.end)
    }

}
