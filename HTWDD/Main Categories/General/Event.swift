//
//  Event.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import Marshal

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

extension Event: Unmarshaling {

    init(object: MarshaledObject) throws {
        self.name = try object <| "name"
        self.period = try EventPeriod(object: object)
    }

}
