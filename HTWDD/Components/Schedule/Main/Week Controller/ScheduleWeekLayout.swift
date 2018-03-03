//
//  ScheduleWeekLayout.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 30.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

private class SeperatorView: CollectionReusableView {
	override func initialSetup() {
		backgroundColor = UIColor.black.withAlphaComponent(0.2)
	}
}

private class IndicatorView: CollectionReusableView {
    override func initialSetup() {
        self.backgroundColor = UIColor.htw.blue.tendingTowards(.white, percentage: 0.85)
    }
}

protocol ScheduleWeekLayoutDataSource: class {
	// MARK: required methods
	var height: CGFloat { get }
    func dateComponentsForItem(at indexPath: IndexPath) -> (begin: DateComponents, end: DateComponents, length: Int)?

	// Mark: optional, have standard implementation
	var widthPerDay: CGFloat { get }
	var startHour: Int { get }
	var endHour: Int { get }
	var itemMargin: CGFloat { get }
    
    var todayIndexPath: IndexPath? { get }
}

extension ScheduleWeekLayoutDataSource {
	var widthPerDay: CGFloat {
		return 100
	}
	var startHour: Int {
		return 7
	}
	var endHour: Int {
		return 21
	}
	var itemMargin: CGFloat {
		return 1
	}
}

class ScheduleWeekLayout: UICollectionViewLayout {

	enum Const {
		static let headerHeight: CGFloat = 48

		static let separation = "separation"
        static let indicator = "indicator"
        static let background = "timeBackground"

		enum Z {
			static let seperator = 0
            static let indicator = 1
			static let lectures = 2
			static let header = 3
            static let background = 4
			static let times = 5
		}
	}

	weak var dataSource: ScheduleWeekLayoutDataSource?
    private var cache = [UICollectionViewLayoutAttributes]()

	init(dataSource: ScheduleWeekLayoutDataSource? = nil) {
		self.dataSource = dataSource
		super.init()
		self.register(SeperatorView.self, forDecorationViewOfKind: Const.separation)
        self.register(IndicatorView.self, forDecorationViewOfKind: Const.indicator)
        self.register(CollectionBackgroundView.self, forDecorationViewOfKind: Const.background)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private var heightPerHour: CGFloat {
		guard let dataSource = self.dataSource else {
			fatalError("Please set dataSource property of ScheduleWeekLayout before calling \(#function)!")
		}
		let start = dataSource.startHour
		let end = dataSource.endHour
		let height = self.collectionViewContentSize.height - Const.headerHeight
		return height / CGFloat(end - start)
	}
    
    func xPosition(ofSection section: Int) -> CGFloat {
        return CGFloat(section) * (self.dataSource?.widthPerDay ?? 0)
    }

	override var collectionViewContentSize: CGSize {

		guard
			let collectionView = self.collectionView,
			let dataSource = self.dataSource
			else {
				return CGSize.zero
		}

		let height = dataSource.height
		let sections = collectionView.dataSource?.numberOfSections?(in: collectionView) ?? 0
		let width = CGFloat(sections) * dataSource.widthPerDay + dataSource.widthPerDay

		return CGSize(width: width, height: height)
	}
    
    override func prepare() {
        self.cache = []
        
        guard let collectionView = self.collectionView, let dataSource = self.dataSource else {
            return
        }
        
        let sections = collectionView.numberOfSections
        
        guard sections > 0 else {
            return
        }
        
        for section in 0..<sections {
            for row in 0..<collectionView.numberOfItems(inSection: section) {
                
                // items
                if let attr = self.layoutAttributesForItem(at: IndexPath(item: row, section: section)) {
                    self.cache.append(attr)
                }
                
            }
            
            // header
            if let attr = self.layoutAttributesForSupplementaryView(ofKind: SupplementaryKind.header.rawValue, at: IndexPath(item: 0, section: section)) {
                self.cache.append(attr)
            }
        }
        
        // today
        if let today = dataSource.todayIndexPath, let attr = self.layoutAttributesForDecorationView(ofKind: Const.indicator, at: today) {
            self.cache.append(attr)
        }
        
        // times
        for row in 0...(Int(dataSource.endHour) - Int(dataSource.startHour) - 1) {
            // time
            if let attr = self.layoutAttributesForSupplementaryView(ofKind: SupplementaryKind.description.rawValue, at: IndexPath(item: row, section: 0)) {
                self.cache.append(attr)
            }
        }
        
        // time background
        if let attr = self.layoutAttributesForDecorationView(ofKind: Const.background, at: .init()) {
            self.cache.append(attr)
        }
    }

	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.cache.filter { $0.frame.intersects(rect) }
	}

	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

		guard let dataSource = self.dataSource else {
			fatalError("Please set dataSource property of ScheduleWeekLayout before calling \(#function)!")
		}

		guard let t = dataSource.dateComponentsForItem(at: indexPath) else {
			return nil
		}

		let margin = dataSource.itemMargin

		let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
		attr.frame.origin.x = CGFloat(indexPath.section) * dataSource.widthPerDay + margin + dataSource.widthPerDay

		attr.frame.origin.y = (t.begin.time / 3600 - CGFloat(dataSource.startHour)) * self.heightPerHour + Const.headerHeight
		attr.frame.size.height = (t.end.time - t.begin.time) / 3600 * self.heightPerHour - 2
		attr.frame.size.width = dataSource.widthPerDay * CGFloat(t.length) - 2 * margin
		attr.zIndex = Const.Z.lectures

		return attr
	}

	override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard let dataSource = self.dataSource else {
			fatalError("Please set dataSource property of ScheduleWeekLayout before calling \(#function)!")
		}

		let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
		if elementKind == SupplementaryKind.header.rawValue {
			attr.frame.origin.x = CGFloat(indexPath.section) * dataSource.widthPerDay + dataSource.widthPerDay
			attr.frame.origin.y = 0
			attr.frame.size.height = Const.headerHeight
			attr.frame.size.width = dataSource.widthPerDay
			attr.zIndex = Const.Z.header
		} else if elementKind == SupplementaryKind.description.rawValue {
			let height = self.heightPerHour
			attr.frame.origin.x = self.collectionView?.contentOffset.x ?? 0
			attr.frame.origin.y = CGFloat(indexPath.row) * height + Const.headerHeight - height / 2
			attr.frame.size.height = height
			attr.frame.size.width = dataSource.widthPerDay
			attr.zIndex = Const.Z.times
        }

		return attr
	}

	override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

		let attr = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        
        if elementKind == Const.separation {
            attr.frame.origin.x = 0
            let height = self.heightPerHour
            attr.frame.origin.y = CGFloat(indexPath.row - 1) * height + Const.headerHeight
            attr.frame.size.width = self.collectionViewContentSize.width
            attr.frame.size.height = 0.5
            attr.zIndex = Const.Z.seperator
        } else if elementKind == Const.indicator {
            guard let dataSource = self.dataSource else {
                return attr
            }
            attr.frame.origin.x = CGFloat(indexPath.section) * dataSource.widthPerDay + dataSource.widthPerDay
            attr.frame.origin.y = 0
            attr.frame.size.height = dataSource.height + Const.headerHeight
            attr.frame.size.width = dataSource.widthPerDay
            attr.zIndex = Const.Z.indicator
        } else if elementKind == Const.background {
            let height = self.collectionViewContentSize.height
            attr.frame.origin.x = self.collectionView?.contentOffset.x ?? 0
            attr.frame.origin.y = 0
            attr.frame.size.height = height
            attr.frame.size.width = dataSource?.widthPerDay ?? 0
            attr.zIndex = Const.Z.background
        }

		return attr
	}

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}

}
