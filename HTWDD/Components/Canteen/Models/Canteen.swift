//
//  Canteen.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

struct Canteen {
    let name: String
    let id: Id
    let coordinate: CLLocationCoordinate2D?

    static let reichenbachstrasse = Canteen(name: "Mensa Reichenbachstraße",
                                            id: .reichenbachstrasse,
                                            coordinate: CLLocationCoordinate2D(latitude: 51.0342243,
                                                                               longitude: 13.7318803))
    static let all = [reichenbachstrasse]

    static func with(id: Id) throws -> Canteen {
        guard let canteen = all.first(where: { $0.id == id }) else {
            throw Canteen.Error.incompatibleCanteen(id: id)
        }
        return canteen
    }

    enum Id: String {
        case reichenbachstrasse = "mensa_reichenbachstraße"

        var imageId: Int {
            switch self {
            case .reichenbachstrasse: return 9
            }
        }
    }
}

extension Canteen {
    enum Error: Swift.Error {
        case incompatibleCanteen(id: Canteen.Id)
    }

    func getMeals() -> Observable<[Meal]> {
        // FIXME: Replace with self-hosted URL
        let escapedID = self.id.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let request = URLRequest(url: URL(string: "http://lucas-vogel.de/mensa2/backend/?mensaId=\(escapedID)")!)
        return URLSession.shared.rx.data(request: request)
            .map { try JSONDecoder().decode([Meal].self, from: $0) }
    }
}
