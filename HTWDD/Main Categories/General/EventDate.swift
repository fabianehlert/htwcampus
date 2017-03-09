//
//  EventDate.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import Marshal

struct EventDate: Hashable {

    let day: Int
    let month: Int
    let year: Int

    var hashValue: Int {
        var hash = 5381
        hash = ((hash << 5) &+ hash) &+ day
        hash = ((hash << 5) &+ hash) &+ month
        hash = ((hash << 5) &+ hash) &+ year
        return hash
    }

    static func ==(lhs: EventDate, rhs: EventDate) -> Bool {
        return lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year
    }
}

extension EventDate: ValueType {

    public static func value(from object: Any) throws -> EventDate {
        guard let raw = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }

        let parts = raw.components(separatedBy: "-").flatMap { Int($0) }
        guard parts.count == 3 else {
            throw MarshalError.typeMismatch(expected: 3, actual: parts.count)
        }

        let newDate = EventDate(day: parts[2], month: parts[1], year: parts[0])

        guard (1...12).contains(newDate.month) else {
            throw MarshalError.typeMismatch(expected: (1...12), actual: newDate.month)
        }

        // it would maybe make sense to check this dependend on the month
        guard (1...31).contains(newDate.day) else {
            throw MarshalError.typeMismatch(expected: (1...31), actual: newDate.day)
        }
        return newDate
    }

}
