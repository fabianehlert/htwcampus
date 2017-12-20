//
//  GenericBasicTableViewDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

class GenericBasicTableViewDataSource<Data: Identifiable>: TableViewDataSource {
    
    private let data: [(String, [Data])]
    init(data: [(String, [Data])]) {
        self.data = data
        super.init()
    }
    
    override func numberOfSections() -> Int {
        return self.data.count
    }
    
    override func numberOfItems(in section: Int) -> Int {
        return self.data[section].1.count
    }
    
    override func item(at index: IndexPath) -> Identifiable? {
        return self.data[index.section].1[index.item]
    }
    
    override func titleFor(section: Int) -> String? {
        return self.data[section].0
    }
    
    func data(at indexPath: IndexPath) -> Data {
        return self.item(at: indexPath) as! Data
    }
    
}
