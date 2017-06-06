//
//  Semester.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import Marshal

enum Semester: Hashable, CustomStringConvertible, Comparable {
    case summer(year: Int)
    case winter(year: Int)

    var year: Int {
        switch self {
        case .summer(let year):
            return year
        case .winter(let year):
            return year
        }
    }

    var description: String {
        switch self {
        case .summer(let year):
            return "SS_\(year)"
        case .winter(let year):
            return "WS_\(year)"
        }
    }

    var hashValue: Int {
        return description.hashValue
    }

    static func <(lhs: Semester, rhs: Semester) -> Bool {
        switch (lhs, rhs) {
        case (.summer(let year1), .summer(let year2)):
            return year1 < year2
        case (.winter(let year1), .winter(let year2)):
            return year1 < year2
        case (.summer(let year1), .winter(let year2)):
            if year1 == year2 {
                return true
            } else {
                return year1 < year2
            }
        case (.winter(let year1), .summer(let year2)):
            if year1 == year2 {
                return false
            } else {
                return year1 < year2
            }
        }
    }

    static func ==(lhs: Semester, rhs: Semester) -> Bool {
        switch (lhs, rhs) {
        case (.summer(let year1), .summer(let year2)):
            return year1 == year2
        case (.winter(let year1), .winter(let year2)):
            return year1 == year2
        default:
            return false
        }
    }
}

extension Semester: ValueType {

    static func value(from object: Any) throws -> Semester {
        guard let number = object as? Int else {
            throw MarshalError.typeMismatch(expected: Int.self, actual: type(of: object))
        }

        let rawValue = "\(number)"

        guard rawValue.characters.count == 5 else {
            throw MarshalError.typeMismatch(expected: 5, actual: rawValue.characters.count)
        }

        var raw = rawValue

        let rawType = raw.characters.removeLast()

        guard let year = Int(raw) else {
            throw MarshalError.typeMismatch(expected: Int.self, actual: raw)
        }
        if rawType == "1" {
            return .summer(year: year)
        } else if rawType == "2" {
            return .winter(year: year)
        } else {
            throw MarshalError.typeMismatch(expected: "1 or 2", actual: rawType)
        }
    }

}
