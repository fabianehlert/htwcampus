//
//  Semester.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

enum Semester: Hashable, CustomStringConvertible, Comparable {
    case summer(year: Int)
    case winter(year: Int)

    init?(rawValue: String) {
        guard rawValue.characters.count == 5 else {
            return nil
        }

        var raw = rawValue

        let type = raw.characters.removeLast()

        guard let year = Int(raw), type == "1" || type == "2" else {
            return nil
        }
        if type == "1" {
            self = .summer(year: year)
        } else if type == "2" {
            self = .winter(year: year)
        } else {
            return nil
        }
    }

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
