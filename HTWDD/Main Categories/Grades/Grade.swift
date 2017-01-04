//
//  Grade.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

struct Grade {

    static func get(sNumber: String, password: String, course: Course) -> Observable<[Grade]> {
        let parameters = [
            "sNummer": sNumber,
            "RZLogin": password,
            "POVersion": course.POVersion,
            "AbschlNr": course.abschlNr,
            "StgNr": course.stgNr
        ]

        return Network.postArray(url: Grade.url, params: parameters, encoding: .url)
    }
}

extension Grade: JSONInitializable {
    static let url = "https://wwwqis.htw-dresden.de/appservice/getgrades"

    init?(json: Any?) {

    }
}
