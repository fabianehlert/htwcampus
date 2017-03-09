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
        let semesterStart = Date.from(day: 14, month: 11, year: 2016)!
        self.dataSource = ScheduleDataSource(originDate: semesterStart, numberOfDays: 20)
        super.init()
        let layout = TimetableCollectionViewLayout(dataSource: self)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.dataSource.collectionView = self.collectionView
        self.collectionView.isDirectionalLockEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Stundenplan"

        self.dataSource.register(type: LectureCollectionViewCell.self)
        self.dataSource.load()
    }

}

extension ScheduleMainVC: TimetableCollectionViewLayoutDataSource {

    var widthPerDay: CGFloat {
        let numberOfDays = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) ? 7 : 3
        return self.view.bounds.width / CGFloat(numberOfDays)
    }

    var height: CGFloat {
        let navbarHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let tabbarHeight = self.tabBarController?.tabBar.bounds.size.height ?? 0
        return self.collectionView.bounds.height - navbarHeight - statusBarHeight - tabbarHeight
    }

    var startHour: CGFloat {
        return 7
    }

    var endHour: CGFloat {
        return 21
    }

    func dateComponentsForItem(at indexPath: IndexPath) -> (begin: DateComponents, end: DateComponents)? {
        guard let item = self.dataSource.lecture(at: indexPath) else {
            return nil
        }
        return (item.begin, item.end)
    }

}
