//
//  CanteenService.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class CanteenService: Service {

    struct Parameters {
        let id: Canteen.Id
        let date: Date
    }

    typealias CanteenInformation = (canteen: Canteen, meals: [Meal])

    func load(parameters: Parameters) -> Observable<CanteenInformation> {
        return Canteen.get(id: parameters.id).flatMap { canteen -> Observable<CanteenInformation> in
            let canteenObservable = Observable.just(canteen)
            let meals = canteen.getMeals(date: parameters.date)
            return Observable.combineLatest(canteenObservable, meals) { (canteen: $0, meals: $1) }
        }
    }

}

// MARK: - Dependency management

extension CanteenService: HasCanteen {
    var canteenService: CanteenService { return self }
}
