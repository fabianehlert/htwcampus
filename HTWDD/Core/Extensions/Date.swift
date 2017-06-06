//
//  Date.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import Marshal

private var dateFormatters = [String: DateFormatter]()
private func dateFormatter(format: String) -> DateFormatter {
    if let cached = dateFormatters[format] {
        return cached
    }
    let new = DateFormatter()
    new.timeZone = TimeZone.current
    new.dateFormat = format
    dateFormatters[format] = new
    return new
}

extension Date {

    static func from(string: String, format: String) throws -> Date {
        guard let date = dateFormatter(format: format).date(from: string) else {
            throw MarshalError.typeMismatch(expected: format, actual: string)
        }
        return date
    }

    static func from(day: Int, month: Int, year: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        var c = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        c.timeZone = TimeZone.autoupdatingCurrent
        return Calendar.current.date(from: c)
    }

    func byAdding(days n: TimeInterval) -> Date {
        return self.addingTimeInterval(n.days)
    }

    var weekday: Day {
        guard let rawDay = self.components.weekday else {
            fatalError("Expected a date to have a weekday.")
        }

        guard let day = Day(rawValue: rawDay - 2 < 0 ? 6 : rawDay - 2) else {
            fatalError("Expected rawDay to be between 1 and 7")
        }
        return day
    }

    var weekNumber: Int {
        let c = Calendar(identifier: .gregorian).dateComponents(in: TimeZone.autoupdatingCurrent, from: self)
        guard let week = c.weekOfYear else {
            fatalError("Expected date to have a week number.")
        }
        return week
    }

    var components: DateComponents {
        return Calendar(identifier: .gregorian).dateComponents(in: TimeZone.autoupdatingCurrent, from: self)
    }

}
