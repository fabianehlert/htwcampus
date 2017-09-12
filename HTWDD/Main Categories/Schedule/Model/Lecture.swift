//
//  Timetable.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 24/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import Marshal

struct Lecture {

    let rooms: [String]
    let weeks: Set<Int>?
    let begin: DateComponents
    let end: DateComponents
    let tag: String?
    let name: String
    let professor: String?
    let type: String
    let week: Week
    let day: Day

    static func get(network: Network, year: String, major: String, group: String) -> Observable<[Lecture]> {
        let parameters = [
            "StgJhr": year,
            "Stg": major,
            "StgGrp": group
        ]

        return network.getArray(url: Lecture.url, params: parameters)
    }

    static func groupByDay(lectures: [Lecture]) -> [Day: [Lecture]] {
        var dayHash = [Day: [Lecture]](minimumCapacity: 7)

        for l in lectures {
            dayHash[l.day, or: []].append(l)
        }

        return dayHash
    }
}

extension Lecture: Unmarshaling {

    static let url = "https://rubu2.rz.htw-dresden.de/API/v0/studentTimetable.php"

    init(object: MarshaledObject) throws {
        self.rooms = try object <| "rooms"
        self.begin = try object <| "beginTime"
        self.end = try object <| "endTime"
        let rawDay: Int = try object <| "day"
        guard let day = Day(rawValue: rawDay - 1) else {
            throw Day.Error.outOfBounds(rawDay - 1)
        }
        self.day = day
        self.tag = try? object <| "lessonTag"
        self.name = try object <| "name"
        self.professor = try? object <| "professor"
        self.type = try object <| "type"
        self.week = try object <| "week"

        let weeksString: String? = try? object <| "weeksOnly"
        if let weeks = weeksString?.components(separatedBy: ";").flatMap({ Int($0) }), !weeks.isEmpty {
            self.weeks = Set(weeks)
        } else {
            self.weeks = nil
        }
    }

}
