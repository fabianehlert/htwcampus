//
//  EventPeriod.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

struct EventPeriod: Hashable {

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

}

extension EventPeriod: JSONInitializable {

    init?(json: Any?) {
        guard let j = json as? [String: String] else {
            return nil
        }
        guard
            let begin = j["beginDay"].flatMap(EventDate.init),
            let end = j["endDay"].flatMap(EventDate.init)
        else {
                return nil
        }
        self.begin = begin
        self.end = end
    }

}
