//
//  ScheduleMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private enum ScheduleLayoutStyle: Int {
	case
	week = 0,
	days = 1,
	list = 2

	var title: String {
		switch self {
		case .week:
			return Loca.Schedule.Style.week
		case .days:
			return Loca.Schedule.Style.days
		case .list:
			return Loca.Schedule.Style.list
		}
	}
}

final class ScheduleMainVC: CollectionViewController {

	// TODO: This should be injected
    var auth: ScheduleService.Auth? {
		didSet {
			self.dataSource.auth = self.auth
			self.dataSource.load()
		}
	}

	static let defaultStartDate = Date()

	private let dataSource: ScheduleDataSource

	fileprivate var lastSelectedIndexPath: IndexPath?

	private lazy var layoutStyleControl: UISegmentedControl = {
		let control = UISegmentedControl(items: [
				ScheduleLayoutStyle.week.title,
				ScheduleLayoutStyle.days.title,
				ScheduleLayoutStyle.list.title
			])
		return control
	}()

	// MARK: - Init

    init(context: AppContext) {
        self.dataSource = ScheduleDataSource(context: context, originDate: ScheduleMainVC.defaultStartDate, numberOfDays: 20, auth: auth)
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
	}

	override func initialSetup() {
		// Basic setup
		self.title = Loca.Schedule.title
		self.tabBarItem.image = #imageLiteral(resourceName: "Class")

		// Layout Style Segmented Control
		self.navigationItem.titleView = self.layoutStyleControl
		self.layoutStyleControl.rx.controlEvent(.valueChanged).subscribe { [weak self] _ in
			if let i = self?.layoutStyleControl.selectedSegmentIndex {
				self?.switchStyle(to: ScheduleLayoutStyle(rawValue: i))
			}
		}.disposed(by: self.rx_disposeBag)

		// TODO: Load preferred style from persistence
		let style = 0
		self.layoutStyleControl.selectedSegmentIndex = style
		self.switchStyle(to: ScheduleLayoutStyle(rawValue: style))

		// CollectionView layout
		let layout = TimetableCollectionViewLayout(dataSource: self)
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

	private func switchStyle(to style: ScheduleLayoutStyle?) {
		guard let style = style else { return }

		switch style {
		case .week:
			break
		case .days:
			break
		case .list:
			break
		}
	}
}

// MARK: - CollectionViewDelegate
extension ScheduleMainVC {
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

// MARK: - TimetableCollectionViewLayoutDataSource
extension ScheduleMainVC: TimetableCollectionViewLayoutDataSource {
	var widthPerDay: CGFloat {
		let numberOfDays = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) ? 7 : 1.5
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
extension ScheduleMainVC: UIViewControllerPreviewingDelegate {
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
extension ScheduleMainVC: AnimatedViewControllerTransitionDataSource {
	func viewForTransition(_ transition: AnimatedViewControllerTransition) -> UIView? {
		return self.lastSelectedIndexPath.flatMap(self.collectionView.cellForItem(at:))
	}
}
