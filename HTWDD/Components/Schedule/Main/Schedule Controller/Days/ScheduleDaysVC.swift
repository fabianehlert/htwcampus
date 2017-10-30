//
//  ScheduleDaysVC.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 30.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

final class ScheduleDaysVC: CollectionViewController {

	// MARK: -

	private let dataSource: ScheduleDataSource

	fileprivate var lastSelectedIndexPath: IndexPath?

	// MARK: - Init

	init(context: AppContext, auth: ScheduleService.Auth?) {
		self.dataSource = ScheduleDataSource(context: context, originDate: ScheduleMainVC.defaultStartDate, numberOfDays: 20, auth: auth)
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func initialSetup() {
		// CollectionView layout
		let layout = ScheduleDaysLayout(dataSource: self)
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
}

// MARK: - ScheduleDaysLayoutDataSource
extension ScheduleDaysVC: ScheduleDaysLayoutDataSource {
	var widthPerDay: CGFloat {
		let numberOfDays = 7
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

// MARK: - UIViewControllerPreviewingDelegate
extension ScheduleDaysVC: UIViewControllerPreviewingDelegate {
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
extension ScheduleDaysVC: AnimatedViewControllerTransitionDataSource {
	func viewForTransition(_ transition: AnimatedViewControllerTransition) -> UIView? {
		return self.lastSelectedIndexPath.flatMap(self.collectionView.cellForItem(at:))
	}
}
