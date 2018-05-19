//
//  URL.swift
//  HTWDD
//
//  Created by martin on 02.05.18.
//  Copyright © 2018 HTW Dresden. All rights reserved.
//

import Foundation

enum CoordinatorRoute: String {
    case schedule
    case scheduleToday
    case exams
    case grades
    case canteen
    case settings
}

extension HTWNamespace where Base == URL {
    static var schemePrefix: String {
        return "htwdd://"
    }
    
    static func route(`for` host: CoordinatorRoute) -> URL? {
        return URL(string: URL.htw.schemePrefix + host.rawValue)
    }
}
