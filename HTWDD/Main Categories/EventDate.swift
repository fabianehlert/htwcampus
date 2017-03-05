//
//  EventDate.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

struct EventDate: Hashable {
    let day: Int
    let month: Int
    let year: Int

    /// Initializes an EventDate with a String in the format 'yyyy-MM-dd'
    ///
    /// - Parameter raw: the EventDate representation as a String
    init?(raw: String) {
        let parts = raw.components(separatedBy: "-").flatMap { Int($0) }
        guard parts.count == 3 else {
            return nil
        }
        self.year = parts[0]
        self.month = parts[1]
        self.day = parts[2]

        guard (1..<12).contains(self.month) else {
            return nil
        }

        // it would maybe make sense to check this dependend on the month
        guard (1..<31).contains(self.day) else {
            return nil
        }
    }

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
