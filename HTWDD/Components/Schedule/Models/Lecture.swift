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

struct Lecture: Codable {

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

        return network.getArrayM(url: Lecture.url, params: parameters)
    }

    static func groupByDay(lectures: [Lecture]) -> [Day: [Lecture]] {
        var dayHash = [Day: [Lecture]](minimumCapacity: 7)

        for l in lectures {
            dayHash[l.day, or: []].append(l)
        }

        return dayHash
    }
}

extension Lecture: Equatable {
    static func ==(lhs: Lecture, rhs: Lecture) -> Bool {
        return lhs.begin == rhs.begin && lhs.end == rhs.end && lhs.tag == rhs.tag && lhs.name == rhs.name && lhs.professor == rhs.professor
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

        let weeksOnly: [Int]? = try? object <| "weeksOnly"
        self.weeks = weeksOnly.map(Set.init)
    }

}
