//
//  TimetableCollectionViewLayout.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 24/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

protocol TimetableCollectionViewLayoutDataSource {
    func widthPerDay() -> CGFloat
    func height() -> CGFloat
    func startHour() -> CGFloat
    func endHour() -> CGFloat
    func dateComponentsForItem(at indexPath: IndexPath) -> (begin: DateComponents, end: DateComponents)?
    func itemMargin() -> CGFloat
}

class TimetableCollectionViewLayout: UICollectionViewLayout {

    var dataSource: TimetableCollectionViewLayoutDataSource {
        guard let d = self.collectionView?.delegate as? TimetableCollectionViewLayoutDataSource else {
            fatalError("Expected \(self.collectionView?.delegate) to be TimetableCollectionViewLayoutDataSource")
        }
        return d
    }

    private var heightPerHour: CGFloat {
        let start = self.dataSource.startHour()
        let end = self.dataSource.endHour()
        let height = self.collectionViewContentSize.height
        return height / (end - start)
    }

    override var collectionViewContentSize: CGSize {

        guard let collectionView = self.collectionView else {
            return CGSize.zero
        }

        let height = self.dataSource.height()
        let sections = collectionView.dataSource?.numberOfSections?(in: collectionView) ?? 0
        let width = CGFloat(sections) * dataSource.widthPerDay()

        return CGSize(width: width, height: height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let itemIndexPaths = self.indexPathsForItemsInRect(rect: rect)

        let itemAttributes = itemIndexPaths.flatMap(self.layoutAttributesForItem(at:))

        return itemAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        guard let t = self.dataSource.dateComponentsForItem(at: indexPath) else {
            return nil
        }

        let margin = self.dataSource.itemMargin()

        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.frame.origin.x = CGFloat(indexPath.section) * self.dataSource.widthPerDay() + margin

        attr.frame.origin.y = (t.begin.time / 3600 - self.dataSource.startHour()) * self.heightPerHour + margin
        attr.frame.size.height = (t.end.time - t.begin.time) / 3600 * self.heightPerHour - 2 * margin
        attr.frame.size.width = self.dataSource.widthPerDay() - 2 * margin

        return attr
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    private func indexPathsForItemsInRect(rect: CGRect) -> [IndexPath] {

        guard let collectionView = self.collectionView else {
            return []
        }

        var indexPaths = [IndexPath]()

        let start = max(Int(floor(rect.origin.x / self.dataSource.widthPerDay())), 0)
        let sections = (collectionView.dataSource?.numberOfSections?(in: collectionView) ?? 1) - 1
        let end = max(Int(floor((rect.origin.x + rect.size.width ) / self.dataSource.widthPerDay())), 0)

        for section in min(start, sections)...min(end, sections) {
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
