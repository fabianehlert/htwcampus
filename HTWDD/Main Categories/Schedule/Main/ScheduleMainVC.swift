//
//  ScheduleMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

// TODO: This should be injected!
let auth = ScheduleDataSource.Auth(year: "2016", major: "044", group: "71")

final class ScheduleMainVC: CollectionViewController {

    private static let defaultStartDate = Date.from(day: 9, month: 10, year: 2017) ?? Date()

    private let dataSource: ScheduleDataSource

    fileprivate var lastSelectedIndexPath: IndexPath?

    init() {
        self.dataSource = ScheduleDataSource(originDate: ScheduleMainVC.defaultStartDate, numberOfDays: 20, auth: auth)
        super.init()
        self.initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        self.dataSource = ScheduleDataSource(originDate: ScheduleMainVC.defaultStartDate, numberOfDays: 20, auth: auth)
        super.init(coder: aDecoder)
        self.initialSetup()
    }

    private func initialSetup() {
        let layout = TimetableCollectionViewLayout(dataSource: self)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.dataSource.collectionView = self.collectionView
        self.collectionView.isDirectionalLockEnabled = true
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
            time.timeString = String(hour)
        }
        self.dataSource.load()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource.lecture(at: indexPath) else {
            Log.error("Expected to get a lecture for indexPath \(indexPath), but got nothing from dataSource..")
            return
        }
        self.lastSelectedIndexPath = indexPath
        let detail = ScheduleDetailVC(lecture:  item)
        detail.transition = AnimatedViewControllerTransition(duration: 0.4, back: self, front: detail)
        detail.modalPresentationStyle = .overCurrentContext
        self.definesPresentationContext = true
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
        return 6.5
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

extension ScheduleMainVC: AnimatedViewControllerTransitionDataSource {

    func viewForTransition(_ transition: AnimatedViewControllerTransition) -> UIView? {
        return self.lastSelectedIndexPath.flatMap(self.collectionView.cellForItem(at:))
    }

}
