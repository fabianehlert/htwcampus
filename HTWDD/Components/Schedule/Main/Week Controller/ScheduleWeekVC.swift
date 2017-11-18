//
//  ScheduleWeekVC.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 30.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

final class ScheduleWeekVC: ScheduleBaseVC {

    private let days = [
        Loca.monday_short,
        Loca.tuesday_short,
        Loca.wednesday_short,
        Loca.thursday_short,
        Loca.friday_short,
        Loca.saturday_short,
        Loca.sunday_short
    ]
	
	private let layout = ScheduleWeekLayout()

	// MARK: - Init

	init(configuration: ScheduleDataSource.Configuration) {
        var config = configuration
        config.splitFreeDaysInDays = false
        super.init(configuration: config, layout: layout)
        layout.dataSource = self
        self.dataSource.delegate = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func initialSetup() {
        super.initialSetup()
        self.collectionView.isDirectionalLockEnabled = true
        
        self.dataSource.register(type: LectureCollectionViewCell.self)
        self.dataSource.registerSupplementary(LectureTimeView.self, kind: .description) { [weak self] time, indexPath in
            guard let `self` = self else {
                return
            }
            let hour = self.startHour + indexPath.row
            time.hour = hour
        }
        self.dataSource.register(type: FreeDayListCell.self) { cell, _, _ in
            cell.label.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi * 1.5)
        }
        self.dataSource.registerSupplementary(CollectionHeaderView.self, kind: .header) { [weak self] view, indexPath in
            guard let `self` = self else { return }
            let info = self.dataSource.dayInformation(indexPath: indexPath)
            view.textAlignment = .center
            let day = NSAttributedString(string: info.date.string(format: "E"), attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)])
            let date = NSAttributedString(string: info.date.string(format: "dd.MM."), attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .light)])
            view.attributedTitle = day + "\n" + date
        }
	}

    override func jumpToToday() {
        self.scrollToToday(animated: true)
    }
    
    private func scrollToToday(animated: Bool) {
        guard let today = self.dataSource.indexPathOfToday else {
            return
        }
        
        // Begin of week (monday)
        let (day, _) = self.dataSource.dayInformation(indexPath: today)
        let section = today.section - day.rawValue
        
        guard self.collectionView.numberOfSections >= section else {
            return
        }
        
        // scroll to item
        let xPos = self.layout.xPosition(ofSection: section)
        self.collectionView.setContentOffset(CGPoint(x: xPos, y: self.collectionView.contentOffset.y), animated: animated)
    }
    
}

// MARK: - ScheduleWeekLayoutDataSource
extension ScheduleWeekVC: ScheduleWeekLayoutDataSource {
	var widthPerDay: CGFloat {
		let numberOfDays = 6
		return self.view.bounds.width / CGFloat(numberOfDays)
	}

	var height: CGFloat {
        let height = (self.tabBarController?.tabBar.top).map { $0 - (self.navigationController?.navigationBar.bottom ?? 0) }
		return height ?? self.collectionView.height
	}

    func dateComponentsForItem(at indexPath: IndexPath) -> (begin: DateComponents, end: DateComponents, length: Int)? {
		if let item = self.dataSource.lecture(at: indexPath) {
			return (item.lecture.begin, item.lecture.end, 1)
		}
        if let freeDay = self.dataSource.freeDay(at: indexPath) {
            return (DateComponents(hour: Int(self.startHour)), DateComponents(hour: Int(self.endHour)), freeDay.period.lengthInDays + 1)
        }
        return nil
	}
    
    var todayIndexPath: IndexPath? {
        return self.dataSource.indexPathOfToday
    }
}

extension ScheduleWeekVC: ScheduleDataSourceDelegate {
    
    func scheduleDataSourceHasFinishedLoading() {
        // we explicitly need to wait for the next run loop
        DispatchQueue.main.async {
            self.scrollToToday(animated: false)
        }
    }
    
    func scheduleDataSourceHasUpdated() {
        
    }
    
}

extension ScheduleWeekVC: TabbarChildViewController {
    func tabbarControllerDidSelectAlreadyActiveChild() {
        self.jumpToToday()
    }
}
