//
//  Date.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

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

struct ParseError: Error {
    enum Kind {
        case typeMismatch
    }
    
    let line: Int
    let kind: Kind
    let message: String?
}

extension Date {

    static func from(string: String, format: String) throws -> Date {
        guard let date = dateFormatter(format: format).date(from: string) else {
            throw ParseError(line: #line, kind: .typeMismatch, message: "Expected: \(format). Actual: \(string)")
        }
        return date
    }

    static func from(day: Int, month: Int, year: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        var c = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        c.timeZone = TimeZone.autoupdatingCurrent
        return Calendar.current.date(from: c)
    }

    func string(format: String) -> String {
        return dateFormatter(format: format).string(from: self)
    }

    func byAdding(days n: TimeInterval) -> Date {
        return self.addingTimeInterval(n.days)
    }
    
    var beginOfWeek: Date {
        return self.byAdding(days: -1 * TimeInterval(self.weekday.rawValue))
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
        let c = Calendar.current.dateComponents(in: TimeZone.current, from: self)
        guard let week = c.weekOfYear else {
            fatalError("Expected date to have a week number.")
        }
        return week
    }

    var components: DateComponents {
        return Calendar.current.dateComponents(in: TimeZone.current, from: self)
    }

    func daysSince(other day: Date) -> Int {
        let cal = Calendar.current
        let components = cal.dateComponents([.day], from: day, to: self)
        return components.day ?? 0
    }

    func sameDayAs(other day: Date) -> Bool {
        let cal = Calendar.current
        let other = cal.dateComponents([.day, .month, .year], from: day)
        let mine = cal.dateComponents([.day, .month, .year], from: self)
        return mine == other
    }

}
