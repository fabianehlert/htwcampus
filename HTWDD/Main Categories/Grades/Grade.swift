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

struct Grade {

    let nr: Int
    let state: String
    let credits: Double
    let text: String
    let semester: Semester
    let numberOfTry: Int
    let date: Date
    let mark: Double
    let note: String?

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

extension Grade: Unmarshaling {
    static let url = "https://wwwqis.htw-dresden.de/appservice/getgrades"

    init(object: MarshaledObject) throws {
        self.nr = try object.value(for: "nr")
        self.state = try object.value(for: "state")
        self.credits = try object.value(for: "credits")
        self.text = try object.value(for: "text")
        self.semester = try object.value(for: "semester")
        self.numberOfTry = try object.value(for: "tries")
        let dateRaw: String = try object.value(for: "examDate")
        self.date = try Date.from(string: dateRaw, format: "yyyy-MM-dd'T'HH:mmZ")
        self.mark = try object.value(for: "grade") / 100
        self.note = try? object.value(for: "note")
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
