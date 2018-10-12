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
        static let margin: CGFloat = 12
    }

    private let collectionViewLayout = CollectionViewFlowLayout()

	// MARK: - Init

	init(configuration: ScheduleDataSource.Configuration) {
        var config = configuration
        config.shouldFilterEmptySections = true
		super.init(configuration: config, layout: self.collectionViewLayout)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func initialSetup() {
        super.initialSetup()
        
        self.collectionView.contentInset = UIEdgeInsets(top: 0,
														left: Const.margin,
														bottom: Const.margin,
														right: Const.margin)

		self.collectionView.isDirectionalLockEnabled = true

		self.dataSource.register(type: LectureListCell.self)
        self.dataSource.register(type: FreeDayListCell.self)
        
        self.dataSource.registerSupplementary(CollectionHeaderView.self, kind: .header) { [weak self] view, indexPath in
            let info = self?.dataSource.dayInformation(indexPath: indexPath)
            let date = NSAttributedString(string: info?.date.string(format: "d. MMMM").uppercased() ?? "",
                                          attributes: [.foregroundColor: UIColor.htw.textBody, .font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
            let day = NSAttributedString(string: info?.date.string(format: "EEEE") ?? "",
                                         attributes: [.foregroundColor: UIColor.htw.textHeadline, .font: UIFont.systemFont(ofSize: 26, weight: .bold)])

            view.attributedTitle = date + "\n" + day
            view.titleInset = Const.margin
        }

		self.dataSource.delegate = self
    }

    override func jumpToToday(animated: Bool = true) {
		DispatchQueue.main.async {
			self.scrollToToday(animated: animated)
		}
    }

    private func scrollToToday(animated: Bool) {
        guard let indexPath = self.dataSource.indexPathOfToday else {
            return
        }
        
        // scroll to item
		if let attributes = self.collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
			self.collectionView.setContentOffset(CGPoint(x: self.collectionView.contentOffset.x,
                                                         y: attributes.frame.origin.y),
                                                 animated: animated)
		} else {
            // Don't scroll to invalid indexPath
            guard self.collectionView.isIndexPathValid(indexPath) else {
                return
            }
			self.collectionView.scrollToItem(at: indexPath,
                                             at: .top,
                                             animated: animated)
		}
    }
    
}

extension ScheduleListVC {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.itemWidth(collectionView: collectionView), height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.itemWidth(collectionView: collectionView)
        
        let height = self.dataSource.height(width: width, indexPath: indexPath) ?? 100
        return CGSize(width: width, height: height)
    }

}

extension ScheduleListVC: ScheduleDataSourceDelegate {

    func scheduleDataSourceHasFinishedLoading() {
        DispatchQueue.main.async {
            self.scrollToToday(animated: false)
        }
    }

    func scheduleDataSourceHasUpdated() {

    }

}

extension ScheduleListVC: TabbarChildViewController {

    func tabbarControllerDidSelectAlreadyActiveChild() {
        self.scrollToToday(animated: true)
    }

}
