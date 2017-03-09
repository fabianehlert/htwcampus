//
//  TimeInterval.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 09/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

extension TimeInterval {

    var minutes: TimeInterval {
        return self * 60
    }

    var hours: TimeInterval {
        return self * 3600
    }

    var days: TimeInterval {
        return self * 86400
    }

}
