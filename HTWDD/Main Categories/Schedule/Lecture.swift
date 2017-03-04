//
//  Timetable.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 24/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

/*
 {
     "Rooms": [
         "S 528"
     ],
     "WeeksOnly": "49;50;51;1;2;3;4;5",
     "beginTime": "09:20:00",
     "day": 1,
     "endTime": "10:50:00",
     "lessonTag": "UF",
     "name": "Unternehmensführung",
     "professor": "Neuvians",
     "type": "V",
     "week": 0
 },
 */

enum Day: Int {
    case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday

    /// Returns a day with the added number of days. (Use negative number to subtract)
    ///
    /// - Parameter days: the number of days to add/subtract.
    /// - Returns: case of Day
    func dayByAdding(days: Int) -> Day {
        var newRawValue = (self.rawValue + days) % 7
        if newRawValue < 0 {
            newRawValue += 7
        }
        return Day(rawValue: newRawValue)!
    }

}

struct Lecture {

    enum Week: Int {
        case all = 0, even, odd
    }

    var rooms: [String]
    var weeks: [Int]
    var begin: DateComponents
    var end: DateComponents
    var tag: String
    var name: String
    var professor: String
    var type: String
    var week: Week
    var day: Day

    static func get(year: String, major: String, group: String) -> Observable<[Lecture]> {
        let parameters = [
            "StgJhr": year,
            "Stg": major,
            "StgGrp": group
        ]
        return Network.getArray(url: Lecture.url, params: parameters)
    }

    static func groupByDay(lectures: [Lecture]) -> [Day: [Lecture]] {
        var dayHash = [Day: [Lecture]](minimumCapacity: 7)

        for l in lectures {
            dayHash[l.day, or: []].append(l)
        }

        return dayHash
    }
}

extension Lecture: JSONInitializable {

    static let url = "https://www2.htw-dresden.de/~app/API/GetTimetable.php"

    init?(json: Any?) {
        guard let j = json as? [String: Any] else {
            return nil
        }

        guard
            let rooms = j["Rooms"] as? [String],
            let begin = (j["beginTime"] as? String).flatMap(DateComponents.timeFromString),
            let end = (j["endTime"] as? String).flatMap(DateComponents.timeFromString),
            let day = (j["day"] as? Int).map({ $0 - 1 }).flatMap(Day.init),
            let tag = j["lessonTag"] as? String,
            let name = j["name"] as? String,
            let professor = j["professor"] as? String,
            let type = j["type"] as? String,
            let week = (j["week"] as? Int).flatMap(Week.init)
            else {
                return nil
        }

        let weeks = (j["WeeksOnly"] as? String).map { $0.components(separatedBy: ";").flatMap { Int($0) } } ?? []

        self.rooms = rooms
        self.begin = begin
        self.end = end
        self.day = day
        self.tag = tag
        self.name = name
        self.professor = professor
        self.type = type
        self.week = week
        self.weeks = weeks
    }

}
