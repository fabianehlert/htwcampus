//
//  Dictionary.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

extension Dictionary {

    subscript(key: Key, or defaultValue: Value) -> Value {
        get {
            return self[key] ?? defaultValue
        }
        set(newValue) {
            self[key] = newValue
        }
    }

    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (Key, Value) {
            for (k, v) in other {
                self[k] = v
            }
    }

    init<S: Sequence>(_ sequence: S)
        where S.Iterator.Element == (Key, Value) {
            self = [:]
            self.merge(sequence)
    }

}
