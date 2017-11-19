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
    
    static let siedepunkt = Canteen(name: "Mensa Siedepunkt",
                                    id: .siedepunkt,
                                    coordinate: CLLocationCoordinate2D(latitude: 51.0295216,
                                                                       longitude: 13.7375996))
    
    static let zeltschloesschen = Canteen(name: "Mensa Zeltschlösschen",
                                          id: .zeltschloesschen,
                                          coordinate: CLLocationCoordinate2D(latitude: 51.03155355,
                                                                             longitude: 13.7286415224337))
    
    static let alteMensa = Canteen(name: "Alte Mensa",
                                   id: .alteMensa,
                                   coordinate: CLLocationCoordinate2D(latitude: 51.0269420344792,
                                                                      longitude: 13.7264835834503))
    
    static let wuEins = Canteen(name: "Mensa WUeins",
                                id: .wuEins,
                                coordinate: CLLocationCoordinate2D(latitude: 51.0298300687576,
                                                                   longitude: 13.7489497661591))
    
    static let bioMensaUboot = Canteen(name: "BioMensa U-Boot",
                                       id: .bioMensaUboot,
                                       coordinate: CLLocationCoordinate2D(latitude: 51.02992515,
                                                                          longitude: 13.7490836869859))
    
    static let mensaBruehl = Canteen(name: "Mensa Brühl",
                                     id: .mensaBruehl,
                                     coordinate: CLLocationCoordinate2D(latitude: 51.0530039,
                                                                        longitude: 13.7419394))
    
    static let stimmGabel = Canteen(name: "Mensa Stimm-Gabel",
                                    id: .stimmGabel,
                                    coordinate: CLLocationCoordinate2D(latitude: 51.05359,
                                                                       longitude: 13.72512))
    
    static let johannStadt = Canteen(name: "Mensa Johannesstadt",
                                     id: .johannStadt,
                                     coordinate: CLLocationCoordinate2D(latitude: 51.0517855,
                                                                        longitude: 13.7596818))
    
    static let paluccaSchule = Canteen(name: "Mensa Palucca Schule",
                                       id: .paluccaSchule,
                                       coordinate: CLLocationCoordinate2D(latitude: 51.02907,
                                                                          longitude: 13.77088))
    
    static let sport = Canteen(name: "Mensa Sport",
                               id: .sport,
                               coordinate: CLLocationCoordinate2D(latitude: 51.06825,
                                                                  longitude: 13.719))
    
    static let mensologie = Canteen(name: "Mensologie",
                                    id: .mensologie,
                                    coordinate: CLLocationCoordinate2D(latitude: 51.052631120726,
                                                                       longitude: 13.7843227386475))
    
    static let kreuzGymnasium = Canteen(name: "Mensa Kreuzgymnasium",
                                        id: .kreuzGymnasium,
                                        coordinate: CLLocationCoordinate2D(latitude: 51.0464933,
                                                                           longitude: 13.8016997))
    
    static let all = [reichenbachstrasse, siedepunkt, zeltschloesschen, alteMensa, wuEins, bioMensaUboot, mensaBruehl, stimmGabel, johannStadt, paluccaSchule, sport, mensologie, kreuzGymnasium]

    static func with(id: Id) throws -> Canteen {
        guard let canteen = all.first(where: { $0.id == id }) else {
            throw Canteen.Error.incompatibleCanteen(id: id)
        }
        return canteen
    }

    enum Id: String {
        case reichenbachstrasse = "mensa_reichenbachstraße"
        case siedepunkt = "mensa_siedepunkt"
        
        case zeltschloesschen
        case alteMensa
        case wuEins
        case bioMensaUboot
        case mensaBruehl
        case stimmGabel
        case johannStadt
        case paluccaSchule
        case sport
        case mensologie
        case kreuzGymnasium
        
        static let all: [Id] = [.reichenbachstrasse, .siedepunkt, .zeltschloesschen, .alteMensa, .wuEins, .bioMensaUboot, .mensaBruehl, .stimmGabel, .johannStadt, .paluccaSchule, .sport, .mensologie, .kreuzGymnasium]
    }
}

extension Canteen {
    enum Error: Swift.Error {
        case incompatibleCanteen(id: Canteen.Id)
    }

    func getMeals(network: Network) -> Observable<[Meal]> {
        return network.getArray(url: "http://lucas-vogel.de/mensa2/backend", params: ["mensaId": self.id.rawValue])
    }
}
