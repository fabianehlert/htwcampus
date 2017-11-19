//
//  AppLecture.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 12.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

/// AppLecture wraps a Lecture with its business logic
struct AppLecture: Codable, Identifiable {
    let lecture: Lecture
    let color: UInt
    let hidden: Bool
}

extension AppLecture: Equatable {
    static func ==(lhs: AppLecture, rhs: AppLecture) -> Bool {
        return lhs.lecture == rhs.lecture
    }
}
