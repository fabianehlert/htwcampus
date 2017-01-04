//
//  Course.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

struct Course {
    var abschlTxt: String
    var POVersion: String
    var abschlNr: String
    var stgNr: String
    var stgTxt: String

    static func get(sNumber: String, password: String) -> Observable<[Course]> {
        let parameters = [
            "sNummer": sNumber,
            "RZLogin": password
        ]

        return Network.postArray(url: Course.url, params: parameters, encoding: .url)
    }
}

extension Course: JSONInitializable {
    static let url = "https://wwwqis.htw-dresden.de/appservice/getcourses"

    init?(json: Any?) {

        guard let j = json as? [String: String] else {
            return nil
        }

        guard
            let abschlTxt = j["AbschlTxt"],
            let POVersion = j["POVersion"],
            let abschlNr = j["AbschlNr"],
            let stgNr = j["StgNr"],
            let stgTxt = j["StgTxt"]
            else {
                return nil
        }

        self.init(abschlTxt: abschlTxt, POVersion: POVersion, abschlNr: abschlNr, stgNr: stgNr, stgTxt: stgTxt)
    }
}
