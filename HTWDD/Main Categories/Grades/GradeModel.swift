//
//  GradeModel.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

protocol GradeSettings: class {
    var sNumber: Setting<String> { get }
    var unixPassword: Setting<String> { get }
}

extension SettingsManager: GradeSettings {}

final class GradeModel {

    weak var settings: GradeSettings?

    init(settings: GradeSettings) {
        self.settings = settings
    }

}
