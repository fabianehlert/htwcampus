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

	static var all: [ScheduleLayoutStyle] {
		return [.week, .days, .list]
	}
}

final class ScheduleMainVC: ViewController {

	// MARK: - Properties

	static let defaultStartDate = Date()

	// TODO: This should be injected
    var auth: ScheduleService.Auth? {
		didSet {
			self.dataSource.auth = self.auth
			self.dataSource.load()
		}
	}

	private let dataSource: ScheduleDataSource

	private var currentScheduleVC: ViewController?

	// MARK: - UI

	/// Segemented control which lets a user switch between the three different schedule layouts.
	private lazy var layoutStyleControl: UISegmentedControl = {
		let control = UISegmentedControl(items: ScheduleLayoutStyle.all.map({ $0.title }))
		return control
	}()

	/// View which contains the ScheduleVC for the type selected in the segmented control.
	private var containerView = View()

	// MARK: - Init

    init(context: AppContext) {
        self.dataSource = ScheduleDataSource(
			context: context,
			originDate: ScheduleMainVC.defaultStartDate,
			numberOfDays: 150,
			auth: auth)
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

		// Setup `containerView`
		self.view.addSubview(self.containerView)
		layoutMatchingEdges(self.containerView, self.view)

		// TODO: Load preferred style from persistence
		let style = 0
		self.layoutStyleControl.selectedSegmentIndex = style
		self.switchStyle(to: ScheduleLayoutStyle(rawValue: style))
	}

	// MARK: - ViewController lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: - Layout

	private func switchStyle(to style: ScheduleLayoutStyle?) {
		guard let style = style else { return }

		if let vc = self.currentScheduleVC {
			vc.willMove(toParentViewController: nil)
			vc.view.removeFromSuperview()
			vc.removeFromParentViewController()

			self.currentScheduleVC = nil
		}

		switch style {
		case .week:
			self.currentScheduleVC = ScheduleWeekVC(dataSource: self.dataSource)
		case .days:
			self.currentScheduleVC = ScheduleDaysVC(dataSource: self.dataSource)
		case .list:
			self.currentScheduleVC = ScheduleListVC(dataSource: self.dataSource)
		}

		self.addChild(self.currentScheduleVC)
		layoutMatchingEdges(self.currentScheduleVC?.view, self.containerView)
	}

	private func addChild(_ child: ViewController?) {
		guard let child = child else { return }
		self.addChildViewController(child)
		self.containerView.addSubview(child.view)
		child.didMove(toParentViewController: self)
	}

	/**
		Activates NSLayoutConstraints that keep the first view _filled_ in the second.
	
		Common usage
		```
		1st view: subView
		2nd view: main view
		```
	*/
	private let layoutMatchingEdges: (UIView?, UIView) -> Void = {
		guard let v = $0 else { return }
		v.translatesAutoresizingMaskIntoConstraints = false

		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				v.leadingAnchor.constraint(equalTo: $1.leadingAnchor),
				v.topAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.topAnchor),
				v.trailingAnchor.constraint(equalTo: $1.trailingAnchor),
				v.bottomAnchor.constraint(equalTo: $1.bottomAnchor)
			])
		} else {
			NSLayoutConstraint.activate([
				v.leadingAnchor.constraint(equalTo: $1.leadingAnchor),
				v.topAnchor.constraint(equalTo: $1.topAnchor),
				v.trailingAnchor.constraint(equalTo: $1.trailingAnchor),
				v.bottomAnchor.constraint(equalTo: $1.bottomAnchor)
			])
		}
	}

}
