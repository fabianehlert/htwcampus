//
//  GenericBasicTableViewDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

class GenericBasicTableViewDataSource<Data: Identifiable>: TableViewDataSource {
    
    private let data: [[Data]]
    init(data: [[Data]]) {
        self.data = data
        super.init()
    }
    
    override func numberOfSections() -> Int {
        return self.data.count
    }
    
    override func numberOfItems(in section: Int) -> Int {
        return self.data[section].count
    }
    
    override func item(at index: IndexPath) -> Identifiable? {
        return self.data[index.section][index.item]
    }
    
    func data(at indexPath: IndexPath) -> Data {
        return self.item(at: indexPath) as! Data
    }
    
}
