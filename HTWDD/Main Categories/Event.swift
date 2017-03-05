//
//  Event.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

struct Event: Hashable {
    let name: String
    let period: EventPeriod

    var hashValue: Int {
        var hash = 5381
        hash = ((hash << 5) &+ hash) &+ name.hashValue
        hash = ((hash << 5) &+ hash) &+ period.hashValue
        return hash
    }

    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.name == rhs.name && lhs.period == rhs.period
    }
}

extension Event: JSONInitializable {

    init?(json: Any?) {
        guard let j = json as? [String: String] else {
            return nil
        }

        guard
            let name = j["name"],
            let period = EventPeriod(json: j)
        else {
                return nil
        }

        self.name = name
        self.period = period
    }

}
