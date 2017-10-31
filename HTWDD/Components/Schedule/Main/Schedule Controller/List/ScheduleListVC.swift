//
//  ScheduleListVC.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 30.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

final class ScheduleListVC: CollectionViewController {

	// MARK: -

	private let dataSource: ScheduleDataSource

	fileprivate var lastSelectedIndexPath: IndexPath?

	// MARK: - Init

	init(dataSource: ScheduleDataSource) {
		self.dataSource = dataSource
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func initialSetup() {
		// CollectionView layout
		let layout = ScheduleListLayout(dataSource: self)
		self.collectionView.backgroundColor = UIColor.htw.veryLightGrey
		self.collectionView.isDirectionalLockEnabled = true
		self.collectionView.setCollectionViewLayout(layout, animated: false)

		// DataSource
		self.dataSource.collectionView = self.collectionView
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

	// MARK: - ViewController lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		self.register3DTouch()

		let doubleTap = UITapGestureRecognizer(target: self, action: #selector(jumpToToday))
		doubleTap.numberOfTapsRequired = 2
		self.collectionView.addGestureRecognizer(doubleTap)
	}

	// MARK: - Private

	private func register3DTouch() {
		guard self.traitCollection.forceTouchCapability == .available else {
			return
		}
		self.registerForPreviewing(with: self, sourceView: self.collectionView)
	}

	fileprivate func presentDetail(_ controller: UIViewController, animated: Bool) {
		self.navigationController?.pushViewController(controller, animated: animated)
	}

	@objc
	private func jumpToToday() {
		self.dataSource.originDate = Date()
		let left = CGPoint(x: -self.collectionView.contentInset.left, y: self.collectionView.contentOffset.y)
		self.collectionView.setContentOffset(left, animated: true)
	}
}

// MARK: - ScheduleListLayoutDataSource
extension ScheduleListVC: ScheduleListLayoutDataSource {
	var widthPerDay: CGFloat {
		let numberOfDays = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) ? 7 : 1
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

// MARK: - CollectionViewDelegate
extension ScheduleListVC {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let item = self.dataSource.lecture(at: indexPath) else {
			Log.error("Expected to get a lecture for indexPath \(indexPath), but got nothing from dataSource..")
			return
		}
		self.lastSelectedIndexPath = indexPath
		let detail = ScheduleDetailVC(lecture: item)
		self.presentDetail(detail, animated: true)
	}
}

// MARK: - UIViewControllerPreviewingDelegate
extension ScheduleListVC: UIViewControllerPreviewingDelegate {
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		guard
			let indexPath = self.collectionView.indexPathForItem(at: location),
			let item = self.dataSource.lecture(at: indexPath)
			else {
				return nil
		}

		if let cell = self.collectionView.cellForItem(at: indexPath) {
			previewingContext.sourceRect = cell.frame
		}

		self.lastSelectedIndexPath = indexPath
		return ScheduleDetailVC(lecture: item)
	}

	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		self.presentDetail(viewControllerToCommit, animated: false)
	}
}

// MARK: - AnimatedViewControllerTransitionDataSource
extension ScheduleListVC: AnimatedViewControllerTransitionDataSource {
	func viewForTransition(_ transition: AnimatedViewControllerTransition) -> UIView? {
		return self.lastSelectedIndexPath.flatMap(self.collectionView.cellForItem(at:))
	}
}
