//
//  DateComponents.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 24/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

extension DateComponents {

    /// Returns DateComponents for the given String.
    ///
    /// - Parameter string: String to be parsed. Should be in format HH:mm:SS!
    /// - Returns: Empty components (0h 0m 0sec) if string could not be parsed, initialized date components otherwise.
    static func time(from string: String) -> DateComponents? {

        guard let date = try? Date.from(string: string, format: "HH:mm:SS") else {
            return nil
        }

        return Calendar.current.dateComponents([.hour, .minute, .second], from: date)
    }

    /// Seconds since 00:00:00
    var time: CGFloat {
        return CGFloat(self.hour ?? 0) * 3600 +
               CGFloat(self.minute ?? 0) * 60 +
               CGFloat(self.second ?? 0)
    }
    
    var eventDate: EventDate? {
        guard let day = self.day, let month = self.month, let year = self.year else {
            return nil
        }
        return EventDate(day: day, month: month, year: year)
    }
    
    /// Checks if self hour and minute is between start and end's hour and minute
    func timeBetween(start: DateComponents, end: DateComponents) -> Bool {
        guard
            let sHour = self.hour, let sMinute = self.minute,
            let stHour = start.hour, let stMinute = start.minute,
            let eHour = end.hour, let eMinute = end.minute
        else {
            return false
        }
        return sHour >= stHour && sHour <= eHour && sMinute >= stMinute && sMinute <= eMinute
    }
    
    func isBefore(other: DateComponents) -> Bool {
        guard
            let sHour = self.hour, let sMinute = self.minute,
            let oHour = other.hour, let oMinute = other.minute
            else {
                return false
        }
        return sHour <= oHour && sMinute <= oMinute
    }
    
    func minus(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> DateComponents {
        var copy = self
        copy.hour = copy.hour ?? 0 - hours
        copy.minute = copy.minute ?? 0 - minutes
        copy.second = copy.second ?? 0 - seconds
        return copy
    }

}
/*
extension DateComponents: ValueType {

    public static func value(from object: Any) throws -> DateComponents {
        guard let string = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }
        let format = "HH:mm:SS"
        guard let components = DateComponents.time(from: string) else {
            throw MarshalError.typeMismatch(expected: format, actual: string)
        }
        return components
    }

}*/

extension DateComponents: Comparable {
    public static func <(lhs: DateComponents, rhs: DateComponents) -> Bool {
        if let y1 = lhs.year, let y2 = rhs.year, y1 != y2 {
            return y1 < y2
        }
        
        if let y1 = lhs.month, let y2 = rhs.month, y1 != y2 {
            return y1 < y2
        }
        
        if let y1 = lhs.day, let y2 = rhs.day, y1 != y2 {
            return y1 < y2
        }
        
        if let y1 = lhs.hour, let y2 = rhs.hour, y1 != y2 {
            return y1 < y2
        }
        
        if let y1 = lhs.minute, let y2 = rhs.minute, y1 != y2 {
            return y1 < y2
        }
        
        if let y1 = lhs.second, let y2 = rhs.second, y1 != y2 {
            return y1 < y2
        }
        
        return true
    }
    
    
}
