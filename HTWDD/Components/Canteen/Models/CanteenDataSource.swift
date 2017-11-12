//
//  CanteenDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class CanteenDataSource: CollectionViewDataSource {

    private var data = [CanteenService.Information]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    private let disposeBag = DisposeBag()
    private let loadingCount = Variable(0)
    
    lazy var loading = self.loadingCount
        .asObservable()
        .map({ $0 > 0 })
        .observeOn(MainScheduler.instance)

    let service: CanteenService
    private(set) var date: Date
    init(context: HasCanteen, date: Date = .init()) {
        self.service = context.canteenService
        self.date = date
    }

    func load() {
        self.loadingCount.value += 1
        
        self.date = Date()
        
        self.service
            .load(parameters: .init(id: .reichenbachstrasse, date: self.date))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                    self?.data = response
                    self?.loadingCount.value -= 1
                }, onError: { [weak self] _ in
                    self?.loadingCount.value -= 1
            })
            .disposed(by: self.disposeBag)
    }

    func titleFor(section: Int) -> String? {
        guard section == 0 else {
            return nil
        }
        return self.data[section].canteen.name
    }
    
    // MARK: TableViewDataSource

    override func numberOfSections() -> Int {
        return self.data.count
    }

    override func numberOfItems(in section: Int) -> Int {
        return self.data[section].meals.count
    }

    override func item(at index: IndexPath) -> Identifiable? {
        return self.data[safe: index.section]?.meals[safe: index.item]
    }

}
