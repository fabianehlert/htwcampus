//
//  DateFormatter.swift
//  HTWDD
//
//  Created by martin on 01.02.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
