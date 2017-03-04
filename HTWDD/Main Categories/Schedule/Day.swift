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
