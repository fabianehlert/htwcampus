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
        let ids: [Canteen.Id]
    }

    struct Information {
        let canteen: Canteen
        let meals: [Meal]
    }

    private let network = Network()
    
    func load(parameters: Parameters) -> Observable<[Information]> {
        do {
            let canteens = try parameters.ids.map({ try Canteen.with(id: $0) })
            let meals = canteens.map { canteen -> Observable<Information> in
                let meals = canteen.getMeals(network: self.network)
                return meals
                    .map { meals in
                        return Information(canteen: canteen, meals: meals.filter( { Calendar.current.isDateInToday($0.date) } ))
                    }
            }
            return Observable
                .combineLatest(meals)
                .map({ $0.filter({ !$0.meals.isEmpty }) })
        } catch {
            return Observable.error(error)
        }
    }

}

// MARK: - Dependency management

extension CanteenService: HasCanteen {
    var canteenService: CanteenService { return self }
}
