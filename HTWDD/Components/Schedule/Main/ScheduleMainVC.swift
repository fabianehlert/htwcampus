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
    list = 0,
	week = 1

	var title: String {
		switch self {
		case .week:
			return Loca.Schedule.Style.week
		case .list:
			return Loca.Schedule.Style.list
		}
	}

	static let all = [ScheduleLayoutStyle.list, .week]
}

final class ScheduleMainVC: ViewController {

	// MARK: - Properties

	static let defaultStartDate = Date()

    var auth: ScheduleService.Auth? {
		didSet {
            self.dataSourceConfiguration.auth = self.auth
            self.cachedStyles.forEach({ _, controller in controller.auth = self.auth })
		}
	}

	private var dataSourceConfiguration: ScheduleDataSource.Configuration

	private var currentScheduleVC: ScheduleBaseVC?

    private var cachedStyles = [ScheduleLayoutStyle: ScheduleBaseVC]()

	// MARK: - UI

	/// Segemented control which lets a user switch between the three different schedule layouts.
	private lazy var layoutStyleControl = UISegmentedControl(items: ScheduleLayoutStyle.all.map({ $0.title }))

	/// View which contains the ScheduleVC for the type selected in the segmented control.
	private var containerView = View()

	// MARK: - Init

    init(context: HasSchedule) {
        self.dataSourceConfiguration = ScheduleDataSource.Configuration(
			context: context,
			originDate: ScheduleMainVC.defaultStartDate,
			numberOfDays: 150,
			auth: self.auth,
            shouldFilterEmptySections: false)
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
	}

	// MARK: - ViewController lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

        // TODO: Load preferred style from persistence
        let style = 0
        self.layoutStyleControl.selectedSegmentIndex = style
        self.switchStyle(to: ScheduleLayoutStyle(rawValue: style))
	}

	// MARK: - Layout

	private func switchStyle(to style: ScheduleLayoutStyle?) {
		guard let style = style else { return }

		if let vc = self.currentScheduleVC {
			vc.willMove(toParentViewController: nil)
			vc.view.removeFromSuperview()
			vc.removeFromParentViewController()
		}

        if let cached = self.cachedStyles[style] {
            self.currentScheduleVC = cached
        } else {
            let newController: ScheduleBaseVC
            switch style {
            case .week:
                newController = ScheduleWeekVC(configuration: self.dataSourceConfiguration)
            case .list:
                newController = ScheduleListVC(configuration: self.dataSourceConfiguration)
            }
            self.cachedStyles[style] = newController
            self.currentScheduleVC = newController
        }

		self.addChild(self.currentScheduleVC)
		layoutMatchingEdges(self.currentScheduleVC?.view, self.containerView)
	}

	private func addChild(_ child: ViewController?) {
		guard let child = child else { return }
		self.addChildViewController(child)
		self.containerView.addSubview(child.view)
		child.didMove(toParentViewController: self)
        self.updateBarButtonItems(navigationItem: child.navigationItem)
	}

    private func updateBarButtonItems(navigationItem: UINavigationItem) {
        self.navigationItem.leftBarButtonItems = navigationItem.leftBarButtonItems
        self.navigationItem.rightBarButtonItems = navigationItem.rightBarButtonItems
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

extension ScheduleMainVC: TabbarChildViewController {

    func tabbarControllerDidSelectAlreadyActiveChild() {
        if let child = self.currentScheduleVC as? TabbarChildViewController {
            child.tabbarControllerDidSelectAlreadyActiveChild()
        }
    }

}
