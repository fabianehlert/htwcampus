//
//  Event.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

struct Event: Codable, Hashable {
    let name: String
    let period: EventPeriod

    var hashValue: Int {
        var hash = 5381
        hash = ((hash << 5) &+ hash) &+ name.hashValue
        hash = ((hash << 5) &+ hash) &+ period.hashValue
        return hash
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case period
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.period = try EventPeriod(from: decoder)
    }
    
    init(name: String, period: EventPeriod) {
        self.name = name
        self.period = period
    }
}

extension Event {
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.name == rhs.name && lhs.period == rhs.period
    }
}
