//
//  DateComponents.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 24/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import Marshal

extension DateComponents {

    /// Returns DateComponents for the given String.
    ///
    /// - Parameter string: String to be parsed. Should be in format HH:mm:SS!
    /// - Returns: Empty components (0h 0m 0sec) if string could not be parsed, initialized date components otherwise.
    static func time(from string: String) -> DateComponents? {

        guard let date = try? Date.from(string: string, format: "HH:mm:SS") else {
            return nil
        }

        return Calendar.current.dateComponents([.hour, .minute, .second], from: date)
    }

    /// Seconds since 00:00:00
    var time: CGFloat {
        return CGFloat(self.hour ?? 0) * 3600 +
               CGFloat(self.minute ?? 0) * 60 +
               CGFloat(self.second ?? 0)
    }

}

extension DateComponents: ValueType {

    enum Error: Swift.Error {
        case wrongType(String)
        case wrongFormat(raw: String, format: String)
    }

    public static func value(from object: Any) throws -> DateComponents {
        guard let string = object as? String else {
            throw Error.wrongType("\(object)")
        }
        guard let components = DateComponents.time(from: string) else {
            throw Error.wrongFormat(raw: string, format: "HH:mm:SS")
        }
        return components
    }

}
