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
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor.htw.grey.cgColor
        self.layer.borderWidth = 1
    }
}

protocol ScheduleWeekLayoutDataSource: class {
	// MARK: required methods
	var height: CGFloat { get }
	func dateComponentsForItem(at indexPath: IndexPath) -> (begin: DateComponents, end: DateComponents)?

	// Mark: optional, have standard implementation
	var widthPerDay: CGFloat { get }
	var startHour: CGFloat { get }
	var endHour: CGFloat { get }
	var itemMargin: CGFloat { get }
    
    var todayIndexPath: IndexPath? { get }
}

extension ScheduleWeekLayoutDataSource {
	var widthPerDay: CGFloat {
		return 100
	}
	var startHour: CGFloat {
		return 6
	}
	var endHour: CGFloat {
		return 20
	}
	var itemMargin: CGFloat {
		return 1
	}
}

class ScheduleWeekLayout: UICollectionViewLayout {

	enum Const {
		static let headerHeight: CGFloat = 40

		static let separation = "separation"
        static let indicator = "indicator"

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

	init(dataSource: ScheduleWeekLayoutDataSource? = nil) {
		self.dataSource = dataSource
		super.init()
		self.register(SeperatorView.self, forDecorationViewOfKind: Const.separation)
        self.register(IndicatorView.self, forDecorationViewOfKind: Const.indicator)
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
		return height / (end - start)
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

	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		let itemIndexPaths = self.indexPathsForItemsInRect(rect: rect)

		let itemAttributes = itemIndexPaths.flatMap(self.layoutAttributesForItem(at:))
		let headerAttributes = self.indexPathsForHeaderViews(in: rect).flatMap {
			return self.layoutAttributesForSupplementaryView(ofKind: SupplementaryKind.header.rawValue, at: $0)
		}
		let timeAttributes = self.indexPathsForTimeViews(in: rect).flatMap {
			return self.layoutAttributesForSupplementaryView(ofKind: SupplementaryKind.description.rawValue, at: $0)
		}
        let timeBackground: [UICollectionViewLayoutAttributes] = self.layoutAttributesForSupplementaryView(ofKind: SupplementaryKind.background.rawValue, at: .init()).map({[$0]}) ?? []
		let decorations = self.indexPathsForDecorationViews(rect: rect).flatMap {
			return self.layoutAttributesForDecorationView(ofKind: Const.separation, at: $0)
		}
        let todayIndicator = self.indexPathsForTodayIndicator(rect: rect).flatMap {
            return self.layoutAttributesForDecorationView(ofKind: Const.indicator, at: $0)
        }
        
        guard itemAttributes.count > 0 else {
            return []
        }

		return itemAttributes + headerAttributes + timeAttributes + decorations + todayIndicator + timeBackground
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

		attr.frame.origin.y = (t.begin.time / 3600 - round(dataSource.startHour)) * self.heightPerHour + Const.headerHeight
		attr.frame.size.height = (t.end.time - t.begin.time) / 3600 * self.heightPerHour - 2
		attr.frame.size.width = dataSource.widthPerDay - 2 * margin
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
			attr.frame.origin.y = CGFloat(indexPath.row - 1) * height + Const.headerHeight - height / 2
			attr.frame.size.height = height
			attr.frame.size.width = dataSource.widthPerDay
			attr.zIndex = Const.Z.times
        } else if elementKind == SupplementaryKind.background.rawValue {
            let height = self.collectionViewContentSize.height
            attr.frame.origin.x = self.collectionView?.contentOffset.x ?? 0
            attr.frame.origin.y = 0
            attr.frame.size.height = height
            attr.frame.size.width = dataSource.widthPerDay
            attr.zIndex = Const.Z.background
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
        }

		return attr
	}

	private func indexPathsForHeaderViews(in rect: CGRect) -> [IndexPath] {
		guard
			let collectionView = self.collectionView,
			let dataSource = self.dataSource
			else {
				return []
		}

		let start = max(Int(floor(rect.origin.x / dataSource.widthPerDay)), 0)
		let sections = (collectionView.dataSource?.numberOfSections?(in: collectionView) ?? 0)
		let end = max(Int(ceil((rect.origin.x + rect.size.width ) / dataSource.widthPerDay)), 0)

		return (min(start, sections)..<min(end, sections)).map { IndexPath(item: 0, section: $0) }
	}

	private func indexPathsForTimeViews(in rect: CGRect) -> [IndexPath] {

		guard let dataSource = self.dataSource else {
			return []
		}

		let startHour = Int(dataSource.startHour)
		let endHour = Int(dataSource.endHour)

		return (0...(endHour-startHour)).map { IndexPath(item: $0 + 1, section: 0) }
	}

	private func indexPathsForDecorationViews(rect: CGRect) -> [IndexPath] {
		// return []
		// maybe we want to have the separators back
		guard let dataSource = self.dataSource else {
			return []
		}

		let startHour = Int(dataSource.startHour)
		let endHour = Int(dataSource.endHour)
		return (0...(endHour-startHour)).map { IndexPath(item: $0 + 1, section: 0) }
	}
    
    private func indexPathsForTodayIndicator(rect: CGRect) -> [IndexPath] {
        guard let today = self.dataSource?.todayIndexPath else {
            return []
        }
        return [today]
    }

	private func indexPathsForItemsInRect(rect: CGRect) -> [IndexPath] {

		guard
			let collectionView = self.collectionView,
			let dataSource = self.dataSource
        else {
				return []
		}

		var indexPaths = [IndexPath]()

		let start = max(Int(floor(rect.origin.x / dataSource.widthPerDay)), 0)
		let sections = (collectionView.dataSource?.numberOfSections?(in: collectionView) ?? 0)
		let end = max(Int(ceil((rect.origin.x + rect.size.width ) / dataSource.widthPerDay)), 0)

		for section in min(start, sections)..<min(end, sections) {
			let itemCount = Int(collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0)
			indexPaths += (0..<itemCount)
				.map { IndexPath(item: $0, section: section) }
		}

		return indexPaths
	}

	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}

}