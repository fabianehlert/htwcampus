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

    static func get() -> Observable<[SemesterInformation]> {
        return Network.getArray(url: SemesterInformation.url)
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
