//
//  UICollectionView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 02.03.18.
//  Copyright © 2018 HTW Dresden. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func isIndexPathValid(_ indexPath: IndexPath) -> Bool {
        return
            indexPath.section < self.numberOfSections &&
            indexPath.item < self.numberOfItems(inSection: indexPath.section)
    }
    
}
