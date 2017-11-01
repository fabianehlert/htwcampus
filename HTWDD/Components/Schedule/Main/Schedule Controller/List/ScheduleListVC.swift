//
//  ScheduleListVC.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 30.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

final class ScheduleListVC: ScheduleBaseVC {

    enum Const {
        static let horizontalMargin: CGFloat = 12
    }

	// MARK: - Init

    private let collectionViewLayout = UICollectionViewFlowLayout()

	init(configuration: ScheduleDataSource.Configuration) {
        var config = configuration
        config.originDate = nil
        config.numberOfDays = nil
        config.shouldFilterEmptySections = true
		super.init(configuration: config, layout: self.collectionViewLayout, startHour: 6.5)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func initialSetup() {
        super.initialSetup()

		self.collectionView.isDirectionalLockEnabled = true

        self.dataSource.register(type: LectureListCell.self)
		self.dataSource.delegate = self
    }

	override func viewDidLoad() {
		super.viewDidLoad()
		self.collectionViewLayout.estimatedItemSize = CGSize(width: self.view.width - (2*Const.horizontalMargin), height: 100)
	}

    override func headerText(day: Day, date: Date, weekdayLoca: String) -> String {
        let dateString = date.string(format: "dd.MM")
        return "\(weekdayLoca) - \(dateString)"
    }

    override func jumpToToday() {
        self.scrollToToday(animated: true)
    }

    private func scrollToToday(animated: Bool) {
        guard let indexPath = self.dataSource.indexPathOfToday else {
            return
        }

        guard self.collectionView.numberOfSections >= indexPath.section else {
            return
        }

        // scroll to header
        let offsetY = self.collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: indexPath)?.frame.origin.y ?? 0
        let contentInsetY = self.collectionView.contentInset.top
        let sectionInsetY = self.collectionViewLayout.sectionInset.top
        self.collectionView.setContentOffset(CGPoint(x: self.collectionView.contentOffset.x, y: offsetY - contentInsetY - sectionInsetY), animated: animated)
    }
}

extension ScheduleListVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.width - Const.horizontalMargin*2, height: 60)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//		let w = self.view.width - Const.horizontalMargin*2
//        return CGSize(width: w, height: w/2)
//    }

}

extension ScheduleListVC: ScheduleDataSourceDelegate {

    func scheduleDataSourceHasFinishedLoading() {
        // we explicitly need to wait for the next run loop
        DispatchQueue.main.async {
            self.scrollToToday(animated: false)
        }
    }

    func scheduleDataSourceHasUpdated() {

    }

}
