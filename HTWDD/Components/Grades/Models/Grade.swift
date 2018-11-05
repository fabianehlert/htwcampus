//
//  Grade.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

struct Grade: Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case nr = "nr"
        case state = "state"
        case credits = "credits"
        case text = "text"
        case semester = "semester"
        case numberOfTry = "tries"
        case date = "examDate"
        case mark = "grade"
        case note = "note"
        case form = "form"
    }
    
    init(nr: Int, state: Status, credits: Double, text: String, semester: Semester, numberOfTry: Int, date: Date?, mark: Double?, note: String?, form: String?) {
        self.nr = nr
        self.state = state
        self.credits = credits
        self.text = text
        self.semester = semester
        self.numberOfTry = numberOfTry
        self.date = date
        self.mark = mark
        self.note = note
        self.form = form
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nr = try container.decode(Int.self, forKey: .nr)
        self.state = try container.decode(Status.self, forKey: .state)
        self.credits = try container.decode(Double.self, forKey: .credits)
        self.text = try container.decode(String.self, forKey: .text)
        self.semester = try container.decode(Semester.self, forKey: .semester)
        self.numberOfTry = try container.decode(Int.self, forKey: .numberOfTry)
        
        let rawDate = try container.decode(String.self, forKey: .date)
        self.date = try Date.from(string: rawDate, format: "yyyy-MM-dd'T'HH:mmZ")
        
        let rawMark = try container.decode(Double.self, forKey: .mark)
        self.mark = rawMark / 100
        
        self.note = try container.decode(String.self, forKey: .note)
        self.form = try container.decode(String.self, forKey: .form)
    }
}

extension Grade: Identifiable { }

extension Grade: Equatable {
    static func ==(lhs: Grade, rhs: Grade) -> Bool {
        return lhs.nr == rhs.nr
            && lhs.mark == rhs.mark
            && lhs.credits == rhs.credits
            && lhs.semester == rhs.semester
            && lhs.state == rhs.state
    }
}

extension Grade {
    static let url = "https://wwwqis.htw-dresden.de/appservice/v2/getgrades"
    
    static func get(network: Network, course: Course) -> Observable<[Grade]> {
        let parameters = [
            "POVersion": "\(course.POVersion)",
            "AbschlNr": course.abschlNr,
            "StgNr": course.stgNr
        ]
        
        return network.getArray(url: Grade.url, params: parameters)
    }
}
