//
//  Timetable.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 24/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

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
    
    enum CodingKeys: String, CodingKey {
        case rooms
        case weeks = "weeksOnly"
        case begin
        case end
        case tag
        case name
        case professor
        case type
        case week
        case day
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.rooms = try container.decode([String].self, forKey: .rooms)
        
        let weeksOnly = try container.decode([Int].self, forKey: .weeks)
        self.weeks = Set(weeksOnly)
        
        self.begin = try container.decode(DateComponents.self, forKey: .begin)
        self.end = try container.decode(DateComponents.self, forKey: .end)
        self.tag = try container.decode(String.self, forKey: .tag)
        self.name = try container.decode(String.self, forKey: .name)
        self.professor = try container.decode(String.self, forKey: .professor)
        self.type = try container.decode(String.self, forKey: .type)
        self.week = try container.decode(Week.self, forKey: .week)
        self.day = try container.decode(Day.self, forKey: .day)
    }
}
/*
extension Lecture: Unmarshaling {
    
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
*/

extension Lecture {
    static let url = "https://rubu2.rz.htw-dresden.de/API/v0/studentTimetable.php"
    
    static func get(network: Network, year: String, major: String, group: String) -> Observable<[Lecture]> {
        let parameters = [
            "StgJhr": year,
            "Stg": major,
            "StgGrp": group
        ]
        return network.getArray(url: Lecture.url, params: parameters)
    }
}

extension Lecture {
    static func groupByDay(lectures: [Lecture]) -> [Day: [Lecture]] {
        var dayHash = [Day: [Lecture]](minimumCapacity: 7)
        
        for l in lectures {
            dayHash[l.day, or: []].append(l)
        }
        
        return dayHash
    }
    
    func fullHash() -> Int {
        // TODO: Parse id of lecture instead (?)
        return self.name.hashValue ^ self.week.hashValue ^ self.day.hashValue ^ self.begin.hashValue ^ self.rooms.joined().hashValue
    }
}

extension Lecture: Equatable {
    static func ==(lhs: Lecture, rhs: Lecture) -> Bool {
        return lhs.begin == rhs.begin && lhs.end == rhs.end && lhs.tag == rhs.tag && lhs.name == rhs.name && lhs.professor == rhs.professor
    }
}
