//
//  EventPeriod.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

struct EventPeriod: Codable, Hashable {
    let begin: EventDate
    let end: EventDate

    var hashValue: Int {
        var hash = 5381
        hash = ((hash << 5) &+ hash) &+ self.begin.hashValue
        hash = ((hash << 5) &+ hash) &+ self.end.hashValue
        return hash
    }
    
    enum CodingKeys: String, CodingKey {
        case begin = "beginDay"
        case end = "endDay"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.begin = try container.decode(EventDate.self, forKey: .begin)
        self.end = try container.decode(EventDate.self, forKey: .end)
    }
    
    init(begin: EventDate, end: EventDate) {
        self.begin = begin
        self.end = end
    }
}

extension EventPeriod {
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
