//
//  SemesterInformation.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import Marshal

struct SemesterInformation {

    let semester: Semester
    var year: Int {
        return semester.year
    }
    let period: EventPeriod
    let freeDays: Set<Event>
    let lectures: EventPeriod
    let exams: EventPeriod
    let reregistration: EventPeriod

    static func get(network: Network) -> Observable<[SemesterInformation]> {
        return network.getArray(url: SemesterInformation.url)
    }

    static func information(date: Date, input: [SemesterInformation]) -> SemesterInformation? {
        for e in input {
            if e.contains(date: date) {
                return e
            }
        }
        return nil
    }

    func contains(date: Date) -> Bool {
        guard let eventDate = EventDate(date: date) else {
            return false
        }
        return self.period.contains(date: eventDate)
    }

    func lecturesContains(date: Date) -> Bool {
        guard let eventDate = EventDate(date: date) else {
            return false
        }
        return self.lectures.contains(date: eventDate)
    }

    func freeDaysContains(date: Date) -> Bool {
        guard let eventDate = EventDate(date: date) else {
            return false
        }

        for d in self.freeDays {
            if d.period.contains(date: eventDate) {
                return true
            }
        }
        return false
    }
}

extension SemesterInformation: Unmarshaling {

    static let url = "https://www2.htw-dresden.de/~app/API/semesterplan.json"

    init(object: MarshaledObject) throws {
        let year: Int = try object <| "year"
        let type: String = try object <| "type"
        if type == "W" {
            self.semester = .winter(year: year)
        } else if type == "S" {
            self.semester = .summer(year: year)
        } else {
            throw MarshalError.typeMismatch(expected: Semester.self, actual: "\(year)\(type)")
        }
        self.period = try object <| "period"
        let freeDays: [Event] = try object <| "freeDays"
        self.freeDays = Set(freeDays)
        self.lectures = try object <| "lecturePeriod"
        self.exams = try object <| "examsPeriod"
        self.reregistration = try object <| "reregistration"
    }

}
