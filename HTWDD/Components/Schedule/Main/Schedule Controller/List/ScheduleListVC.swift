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

    private let collectionViewLayout = UICollectionViewFlowLayout()

	init(configuration: ScheduleDataSource.Configuration) {
        var config = configuration
        config.shouldFilterEmptySections = true
		super.init(configuration: configuration, layout: self.collectionViewLayout, startHour: 6.5)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func initialSetup() {
        super.initialSetup()

		self.collectionView.isDirectionalLockEnabled = true
    }
}

extension ScheduleListVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.width - 8*2, height: 60)
    }

}
