//
//  CodableDictionary.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 02.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

// Copied from https://stackoverflow.com/questions/44725202/swift-4-decodable-dictionary-with-enum-as-key
struct CodableDictionary<Key: Hashable, Value: Codable>: Codable where Key: CodingKey {
    
    let decoded: [Key: [Value]]
    
    init(_ decoded: [Key: [Value]]) {
        self.decoded = decoded
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        decoded = Dictionary(uniqueKeysWithValues:
            try container.allKeys.lazy.map {
                (key: $0, value: try container.decode([Value].self, forKey: $0))
            }
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        for (key, value) in decoded {
            try container.encode(value, forKey: key)
        }
    }
}
