//
//  DateComponents.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 24/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

extension DateComponents {

    /// Returns DateComponents for the given String.
    ///
    /// - Parameter string: String to be parsed. Should be in format HH:mm:SS!
    /// - Returns: Empty components (0h 0m 0sec) if string could not be parsed, initialized date components otherwise.
    static func timeFromString(_ string: String) -> DateComponents? {

        guard let date = Date.fromString(string, format: "HH:mm:SS") else {
            return DateComponents()
        }

        return Calendar.current.dateComponents([.hour, .minute, .second], from: date)
    }

}
