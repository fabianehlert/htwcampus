//
//  TimetableCollectionViewLayout.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 24/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

protocol TimetableCollectionViewLayoutDataSource: class {
    // MARK: required methods
    var height: CGFloat { get }
    func dateComponentsForItem(at indexPath: IndexPath) -> (begin: DateComponents, end: DateComponents)?

    // Mark: optional, have standard implementation
    var widthPerDay: CGFloat { get }
    var startHour: CGFloat { get }
    var endHour: CGFloat { get }
    var itemMargin: CGFloat { get }
}

extension TimetableCollectionViewLayoutDataSource {
    var widthPerDay: CGFloat {
        return 120
    }
    var startHour: CGFloat {
        return 0
    }
    var endHour: CGFloat {
        return 24
    }
    var itemMargin: CGFloat {
        return 2
    }
}

class TimetableCollectionViewLayout: UICollectionViewLayout {

    private enum Const {
        static let headerHeight: CGFloat = 40
    }

    private(set) weak var dataSource: TimetableCollectionViewLayoutDataSource?

    init(dataSource: TimetableCollectionViewLayoutDataSource) {
        self.dataSource = dataSource
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var heightPerHour: CGFloat {
        guard let dataSource = self.dataSource else {
            fatalError("Please set dataSource property of TimetableCollectionViewLayout before calling \(#function)!")
        }
        let start = dataSource.startHour
        let end = dataSource.endHour
        let height = self.collectionViewContentSize.height - Const.headerHeight
        return height / (end - start)
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
        let width = CGFloat(sections) * dataSource.widthPerDay

        return CGSize(width: width, height: height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let itemIndexPaths = self.indexPathsForItemsInRect(rect: rect)

        let itemAttributes = itemIndexPaths.flatMap(self.layoutAttributesForItem(at:))
        let headerAttributes = self.indexPathsForHeaderViews(in: rect).flatMap {
            return self.layoutAttributesForSupplementaryView(ofKind: SupplementaryKind.header.rawValue, at: $0)
        }

        return itemAttributes + headerAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        guard let dataSource = self.dataSource else {
            fatalError("Please set dataSource property of TimetableCollectionViewLayout before calling \(#function)!")
        }

        guard let t = dataSource.dateComponentsForItem(at: indexPath) else {
            return nil
        }

        let margin = dataSource.itemMargin

        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.frame.origin.x = CGFloat(indexPath.section) * dataSource.widthPerDay + margin

        attr.frame.origin.y = (t.begin.time / 3600 - dataSource.startHour) * self.heightPerHour + margin + Const.headerHeight
        attr.frame.size.height = (t.end.time - t.begin.time) / 3600 * self.heightPerHour - 2 * margin
        attr.frame.size.width = dataSource.widthPerDay - 2 * margin

        return attr
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let dataSource = self.dataSource else {
            fatalError("Please set dataSource property of TimetableCollectionViewLayout before calling \(#function)!")
        }

        let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        attr.frame.origin.x = CGFloat(indexPath.section) * dataSource.widthPerDay
        attr.frame.origin.y = 0
        attr.frame.size.height = Const.headerHeight
        attr.frame.size.width = dataSource.widthPerDay

        return attr
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
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
