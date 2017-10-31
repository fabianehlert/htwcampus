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

	// MARK: - Init

	init(dataSource: ScheduleDataSource) {
		let layout = ScheduleListLayout()
		super.init(dataSource: dataSource, layout: layout, startHour: 6.5)
        layout.dataSource = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func initialSetup() {
        super.initialSetup()

		self.collectionView.isDirectionalLockEnabled = true
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
