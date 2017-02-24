//
//  TimetableCollectionViewLayout.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 24/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

protocol TimetableCollectionViewLayoutDataSource {
    func numberOfDays() -> Int
    func widthPerDay() -> CGFloat
}

class TimetableCollectionViewLayout: UICollectionViewLayout {

    var dataSource: TimetableCollectionViewLayoutDataSource?

    override var collectionViewContentSize: CGSize {

        assert(dataSource != nil)
        guard let dataSource = self.dataSource else {
            return CGSize.zero
        }

        let height = self.collectionView?.bounds.size.height ?? 0
        let width = CGFloat(dataSource.numberOfDays()) * dataSource.widthPerDay()

        return CGSize(width: width, height: height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return nil
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
