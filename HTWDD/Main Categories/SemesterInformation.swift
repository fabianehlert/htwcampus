//
//  SemesterInformation.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

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

extension SemesterInformation: JSONInitializable {

    static let url = "https://www2.htw-dresden.de/~app/API/semesterplan.json"

    init?(json: Any?) {
        guard let j = json as? [String: Any] else {
            return nil
        }

        guard
            let year = j["year"] as? Int,
            let type = j["type"] as? String,
            let period = EventPeriod(json: j["period"]),
            let freeDays = (j["freeDays"] as? [Any])?.flatMap(Event.init),
            let lectures = EventPeriod(json: j["lecturePeriod"]),
            let exams = EventPeriod(json: j["examsPeriod"]),
            let reregistration = EventPeriod(json: j["reregistration"])
        else {
                return nil
        }

        if type == "W" {
            self.semester = .winter(year: year)
        } else if type == "S" {
            self.semester = .summer(year: year)
        } else {
            return nil
        }

        self.period = period
        self.freeDays = Set(freeDays)
        self.lectures = lectures
        self.exams = exams
        self.reregistration = reregistration
    }

}
