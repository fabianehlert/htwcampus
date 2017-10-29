//
//  Canteen.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import CoreLocation
import OpenMensaKit
import RxSwift

struct Canteen {

    enum Id: Int {
        case reichenbachstrasse = 80
    }

    let id: Id
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D?

    private let canteen: OpenMensaKit.Canteen

    init?(_ openMensaCanteen: OpenMensaKit.Canteen) {
        guard let id = Id(rawValue: openMensaCanteen.id) else {
            return nil
        }
        self.id = id
        self.name = openMensaCanteen.name
        self.address = openMensaCanteen.address
        self.coordinate = openMensaCanteen.coordinate

        self.canteen = openMensaCanteen
    }

}

extension Canteen {

    enum Error: Swift.Error {
        case incompatibleCanteen(id: Int)
    }

    static func get(id: Id) -> Observable<Canteen> {
        return Observable.create { observer in

            OpenMensaKit.Canteen.get(withID: id.rawValue) { result in
                switch result {
                case .success(let canteen):
                    guard let c = Canteen(canteen) else {
                        observer.onError(Error.incompatibleCanteen(id: canteen.id))
                        return
                    }
                    observer.onNext(c)
                    observer.onCompleted()
                case .failure(let err):
                    observer.onError(err)
                }
            }

            return Disposables.create()
        }
    }

    func getMeals(date: Date) -> Observable<[Meal]> {
        return Observable.create { observer in

            self.canteen.getMeals(forDay: date, completion: { result in
                switch result {
                case .success(let meals):
                    let mapped = meals.map(Meal.init)
                    observer.onNext(mapped)
                    observer.onCompleted()
                case .failure(let err):
                    observer.onError(err)
                }
            })

            return Disposables.create()
        }
    }

}
