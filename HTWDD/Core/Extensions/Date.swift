//
//  Date.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

private var dateFormatters = [String: DateFormatter]()
private func dateFormatter(format: String) -> DateFormatter {
    if let cached = dateFormatters[format] {
        return cached
    }
    let new = DateFormatter()
    new.timeZone = TimeZone.current
    new.dateFormat = format
    dateFormatters[format] = new
    return new
}

extension Date {

    static func fromString(_ string: String, format: String) -> Date? {
        return dateFormatter(format: format).date(from: string)
    }

}
