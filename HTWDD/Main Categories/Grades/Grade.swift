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

    var nr: Int
    var status: String
    var credits: Double
    var text: String
    var semester: Semester
    var numberOfTry: Int
    var date: Date
    var mark: Double
    var note: String?

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

    /// Groups and sorts a given array of grades by their semester.
    ///
    /// - Parameter grades: the array that should be sorted
    /// - Returns: array of semesters + their grades, already sorted by semester
    static func groupAndOrderBySemester(grades: [Grade]) -> [(Semester, [Grade])] {

        var semesterHash = [Semester: [Grade]]()

        for grade in grades {
            semesterHash[grade.semester, or: []].append(grade)
        }

        return semesterHash.sorted {
            return $0.key < $1.key
        }
    }
}

extension Grade: JSONInitializable {
    static let url = "https://wwwqis.htw-dresden.de/appservice/getgrades"

    init?(json: Any?) {
        guard let j = json as? [String: String] else {
            return nil
        }

        guard
            let nr = j["PrNr"].flatMap({ Int($0) }),
            let status = j["Status"],
            let credits = j["EctsCredits"].flatMap({ Double($0) }),
            let text = j["PrTxt"],
            let semester = j["Semester"].flatMap({ Semester(rawValue: $0) }),
            let numberOfTry = j["Versuch"].flatMap({ Int($0) }),
            let date = j["PrDatum"].flatMap({ Date.fromString($0, format: "dd.MM.yyyy") }),
            let mark = j["PrNote"].flatMap({ Double($0) }).map({ $0 / 100 })
        else {
                return nil
        }

        self.nr = nr
        self.status = status
        self.credits = credits
        self.text = text
        self.semester = semester
        self.numberOfTry = numberOfTry
        self.date = date
        self.mark = mark
        self.note = j["Vermerk"].flatMap { $0.isEmpty ? nil : $0 }

    }
}

extension Grade: Equatable {

    static func ==(lhs: Grade, rhs: Grade) -> Bool {
        return lhs.nr == rhs.nr
            && lhs.mark == rhs.mark
            && lhs.credits == rhs.credits
            && lhs.semester == rhs.semester
    }

}
