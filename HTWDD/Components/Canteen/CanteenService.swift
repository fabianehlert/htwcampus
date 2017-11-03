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
        do {
            let canteen = try Canteen.with(id: parameters.id)
            let meals = canteen.getMeals()
            return Observable.combineLatest(Observable.just(canteen), meals) { (canteen: $0, meals: $1) }
        } catch {
            return Observable.error(error)
        }
    }

}

// MARK: - Dependency management

extension CanteenService: HasCanteen {
    var canteenService: CanteenService { return self }
}
