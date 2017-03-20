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

        self.title = Loca.scheduleTitle

        self.dataSource.register(type: LectureCollectionViewCell.self)
        self.dataSource.registerSupplementary(LectureHeaderView.self, kind: .header) { [weak self] view, indexPath in
            view.title = self?.dataSource.dayName(indexPath: indexPath) ?? ""
        }
        self.dataSource.registerSupplementary(LectureTimeView.self, kind: .description) { [weak self] time, indexPath in
            guard let `self` = self else {
                return
            }
            let hour = Int(self.startHour) - 1 + indexPath.row
            time.timeString = "\(hour)"
        }
        self.dataSource.load()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = ScheduleDetailVC()
        detail.transition = AnimatedViewControllerTransition(back: self, front: detail)
        self.present(detail, animated: true, completion: nil)
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
        return self.collectionView.bounds.height - navbarHeight - statusBarHeight - tabbarHeight - 25.0
    }

    var startHour: CGFloat {
        return 7
    }

    var endHour: CGFloat {
        return 19
    }

    func dateComponentsForItem(at indexPath: IndexPath) -> (begin: DateComponents, end: DateComponents)? {
        guard let item = self.dataSource.lecture(at: indexPath) else {
            return nil
        }
        return (item.begin, item.end)
    }

}

extension ScheduleMainVC: AnimatedViewControllerTransitionDataSource {

    func viewForTransition(_ transition: AnimatedViewControllerTransition) -> UIView {
        let cells = self.collectionView.indexPathsForSelectedItems?.flatMap(self.collectionView.cellForItem(at:))
        return (cells?.first)!
    }

}
