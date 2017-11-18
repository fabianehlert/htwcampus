//
//  Grade.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import Marshal

struct Grade: Codable, Identifiable {

    enum Status: String, Codable {
        case signedUp = "AN"
        case passed = "BE"
        case failed = "NB"
        case ultimatelyFailed = "EN"
        
        var localizedDescription: String {
            switch self {
            case .signedUp: return Loca.Grades.status.signedUp
            case .passed: return Loca.Grades.status.passed
            case .failed: return Loca.Grades.status.failed
            case .ultimatelyFailed: return Loca.Grades.status.ultimatelyFailed
            }
        }
    }

    let nr: Int
    let state: Status
    let credits: Double
    let text: String
    let semester: Semester
    let numberOfTry: Int
    let date: Date?
    let mark: Double?
    let note: String?
    let form: String?

    static func get(network: Network, course: Course) -> Observable<[Grade]> {
        let parameters = [
            "POVersion": "\(course.POVersion)",
            "AbschlNr": course.abschlNr,
            "StgNr": course.stgNr
        ]

        return network.getArrayM(url: Grade.url, params: parameters)
    }

}

extension Grade: Unmarshaling {
    static let url = "https://wwwqis.htw-dresden.de/appservice/v2/getgrades"

    init(object: MarshaledObject) throws {
        self.nr = try object <| "nr"
        self.state = try object <| "state"
        self.credits = try object <| "credits"
        self.text = try object <| "text"
        self.semester = try object <| "semester"
        self.numberOfTry = try object <| "tries"

        let dateRaw: String? = try object <| "examDate"
        self.date = try dateRaw.map {
             try Date.from(string: $0, format: "yyyy-MM-dd'T'HH:mmZ")
        }

        let markRaw: Double? = try object <| "grade"
        self.mark = markRaw.map { $0 / 100 }

        self.note = try? object <| "note"
        self.form = try? object <| "form"
    }

}

extension Grade: Equatable {

    static func ==(lhs: Grade, rhs: Grade) -> Bool {
        return lhs.nr == rhs.nr
            && lhs.mark == rhs.mark
            && lhs.credits == rhs.credits
            && lhs.semester == rhs.semester
            && lhs.state == rhs.state
    }

}
