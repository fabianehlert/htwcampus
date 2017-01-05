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

    enum Semester: Hashable, CustomStringConvertible, Comparable {
        case summer(year: Int)
        case winter(year: Int)

        init?(rawValue: String) {
            guard rawValue.characters.count == 5 else {
                return nil
            }

            var raw = rawValue

            let type = raw.characters.removeLast()

            guard let year = Int(raw), type == "1" || type == "2" else {
                return nil
            }
            if type == "1" {
                self = .summer(year: year)
            } else if type == "2" {
                self = .winter(year: year)
            } else {
                return nil
            }
        }

        var year: Int {
            switch self {
            case .summer(let year):
                return year
            case .winter(let year):
                return year
            }
        }

        var description: String {
            switch self {
            case .summer(let year):
                return "SS_\(year)"
            case .winter(let year):
                return "WS_\(year)"
            }
        }

        var hashValue: Int {
            return description.hashValue
        }

        static func <(lhs: Semester, rhs: Semester) -> Bool {
            switch (lhs, rhs) {
            case (.summer(let year1), .summer(let year2)):
                return year1 < year2
            case (.winter(let year1), .winter(let year2)):
                return year1 < year2
            case (.summer(let year1), .winter(let year2)):
                if year1 == year2 {
                    return true
                } else {
                    return year1 < year2
                }
            case (.winter(let year1), .summer(let year2)):
                if year1 == year2 {
                    return false
                } else {
                    return year1 < year2
                }
            }
        }

        static func ==(lhs: Semester, rhs: Semester) -> Bool {
            switch (lhs, rhs) {
            case (.summer(let year1), .summer(let year2)):
                return year1 == year2
            case (.winter(let year1), .winter(let year2)):
                return year1 == year2
            default:
                return false
            }
        }
    }

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
