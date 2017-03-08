//
//  Course.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import Marshal

struct Course {
    let abschlTxt: String
    let POVersion: String
    let abschlNr: String
    let stgNr: String
    let stgTxt: String

    static func get(sNumber: String, password: String) -> Observable<[Course]> {
        let parameters = [
            "sNummer": sNumber,
            "RZLogin": password
        ]

        return Network.postArray(url: Course.url, params: parameters, encoding: .url)
    }

}

extension Course: Unmarshaling {
    static let url = "https://wwwqis.htw-dresden.de/appservice/getcourses"

    init(object: MarshaledObject) throws {
        self.abschlTxt = try object <| "AbschlTxt"
        self.POVersion = try object <| "POVersion"
        self.abschlNr = try object <| "AbschlNr"
        self.stgNr = try object <| "StgNr"
        self.stgTxt = try object <| "StgTxt"
    }

}
