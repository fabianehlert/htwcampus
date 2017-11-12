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

    struct Information {
        let canteen: Canteen
        let meals: [Meal]
    }

    private let network = Network()
    
    func load(parameters: Parameters) -> Observable<[Information]> {
        do {
            let canteen = try Canteen.with(id: parameters.id)
            let meals = canteen.getMeals(network: self.network)
            return meals.map { meals in
                guard !meals.isEmpty else {
                    return []
                }
                return [Information(canteen: canteen, meals: meals)]
            }
        } catch {
            return Observable.error(error)
        }
    }

}

// MARK: - Dependency management

extension CanteenService: HasCanteen {
    var canteenService: CanteenService { return self }
}
