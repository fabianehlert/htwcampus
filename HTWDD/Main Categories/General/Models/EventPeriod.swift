//
//  EventPeriod.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import Marshal

struct EventPeriod: Codable, Hashable {

    let begin: EventDate
    let end: EventDate

    var hashValue: Int {
        var hash = 5381
        hash = ((hash << 5) &+ hash) &+ begin.hashValue
        hash = ((hash << 5) &+ hash) &+ end.hashValue
        return hash
    }

    static func ==(lhs: EventPeriod, rhs: EventPeriod) -> Bool {
        return lhs.begin == rhs.begin && lhs.end == rhs.end
    }

    func contains(date: EventDate) -> Bool {
        if end.date < begin.date {
            Log.error("In line \(#line) in \(#file): upperBound of a range should not be smaller than the lowerBound! Investigate if data in backend is inconsistent!")
            return false
        }
        return (begin.date...end.date).contains(date.date)
    }

    var lengthInDays: Int {
        return self.end.date.daysSince(other: self.begin.date)
    }
}

extension EventPeriod: Unmarshaling {

    init(object: MarshaledObject) throws {
        self.begin = try object.value(for: "beginDay")
        self.end = try object.value(for: "endDay")
    }

}
