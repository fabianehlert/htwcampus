//
//  EventDate.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

struct EventDate: Codable, Hashable {

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

extension EventDate {

    init?(date: Date) {
        let components = date.components
        guard
            let year = components.year,
            let month = components.month,
            let day = components.day
            else {
                return nil
        }
        self.year = year
        self.month = month
        self.day = day
    }

    var date: Date {
        let calendar = Calendar.current
        // hour 12 to get rid of summer/winter time issues -> is always in the middle of the day
        let components = DateComponents(calendar: calendar, timeZone: TimeZone.current, year: self.year, month: self.month, day: self.day, hour: 12)
        return calendar.date(from: components)!
    }

}

extension EventDate {

    private enum ParseError: Error {
        case wrongType
    }
    
    public static func value(from object: Any) throws -> EventDate {
        guard let raw = object as? String else {
            throw ParseError.wrongType
        }

        let parts = raw.components(separatedBy: "-").compactMap { s -> Int? in Int(s) }
        guard parts.count == 3 else {
            throw ParseError.wrongType
        }

        let newDate = EventDate(day: parts[2], month: parts[1], year: parts[0])

        guard Set(1...12).contains(newDate.month) else {
            throw ParseError.wrongType
        }

        // it would maybe make sense to check this dependend on the month
        guard Set(1...31).contains(newDate.day) else {
            throw ParseError.wrongType
        }
        return newDate
    }

}
