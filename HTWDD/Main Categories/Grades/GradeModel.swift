//
//  GradeModel.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

protocol GradeSettings: class {
    var sNumber: Setting<String> { get }
    var unixPassword: Setting<String> { get }
}

extension SettingsManager: GradeSettings {}

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

final class GradeModel {

    weak var settings: GradeSettings?

    init(settings: GradeSettings) {
        self.settings = settings
    }

}
