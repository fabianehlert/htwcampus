//
//  GenericBasicCollectionViewDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

class GenericBasicCollectionViewDataSource<Data: Identifiable>: CollectionViewDataSource {
    
    private let data: [Data]
    init(data: [Data]) {
        self.data = data
        super.init()
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    
    override func numberOfItems(in section: Int) -> Int {
        return self.data.count
    }
    
    override func item(at index: IndexPath) -> Identifiable? {
        return self.data[index.item]
    }
    
    func data(at indexPath: IndexPath) -> Data {
        return self.item(at: indexPath) as! Data
    }
    
}
