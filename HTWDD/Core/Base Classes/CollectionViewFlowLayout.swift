//
//  CollectionViewFlowLayout.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 02.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
