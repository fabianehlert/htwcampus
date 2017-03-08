//
//  Day.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

enum Day: Int {
    case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday

    enum Error: Swift.Error {
        case outOfBounds(Int)
    }

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

    /// Returns the week number, if adding `addingDays` days and current is `starting`.
    ///
    /// - Parameters:
    ///   - starting: week number of the current day
    ///   - addingDays: number of days to add
    /// - Returns: a week number between 1 and 52
    func weekNumber(starting: Int, addingDays: Int) -> Int {
        let completeWeeks = addingDays / 7
        let overflow: Int = (self.rawValue + addingDays % 7) > 6 ? 1 : 0
        let weeks = completeWeeks + overflow
        var newWeek = starting + weeks
        while newWeek > 52 {
            newWeek -= 52
        }
        return newWeek
    }

}
