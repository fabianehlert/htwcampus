//
//  CanteenDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class CanteenDataSource: TableViewDataSource {

    private var canteen: Canteen?
    private var meals = [Meal]()
    private let disposeBag = DisposeBag()

    let service: CanteenService
    init(context: AppContext) {
        self.service = context.canteenService
    }

    func load() -> Observable<()> {
        // TODO: Use correct date here!
        return self.service
            .load(parameters: .init(id: .reichenbachstrasse, date: Date().byAdding(days: 1)))
            .observeOn(MainScheduler.instance)
            .map { [weak self] response in
                self?.canteen = response.canteen
                self?.meals = response.meals
                self?.tableView?.reloadData()
            }
    }

    // MARK: TableViewDataSource

    override func numberOfSections() -> Int {
        return self.canteen != nil ? 1 : 0
    }

    override func titleFor(section: Int) -> String? {
        guard section == 0 else {
            return nil
        }
        return self.canteen?.name
    }

    override func numberOfItems(in section: Int) -> Int {
        return self.meals.count
    }

    override func item(at index: IndexPath) -> Identifiable? {
        return self.meals[safe: index.row]
    }

}
