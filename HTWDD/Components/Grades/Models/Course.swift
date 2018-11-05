//
//  Course.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

struct Course: Codable {
    let abschlTxt: String
    let POVersion: Int
    let abschlNr: String
    let stgNr: String
    let stgTxt: String
    
    enum CodingKeys: String, CodingKey {
        case abschlTxt = "AbschlTxt"
        case POVersion = "POVersion"
        case abschlNr = "AbschlNr"
        case stgNr = "StgNr"
        case stgTxt = "StgTxt"
    }
}

extension Course {
    static let url = "https://wwwqis.htw-dresden.de/appservice/v2/getcourses"
    
    static func get(network: Network) -> Observable<[Course]> {
        return network.getArray(url: Course.url)
    }
}
