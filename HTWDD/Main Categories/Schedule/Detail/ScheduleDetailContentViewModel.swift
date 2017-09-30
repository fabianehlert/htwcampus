//
//  ScheduleDetailContentViewModel.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30.09.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

class ScheduleDetailContentViewModel {

    private let lecture: Lecture

    init(lecture: Lecture) {
        self.lecture = lecture
    }

    var tag: String {
        return self.lecture.tag ?? ""
    }

    var title: String {
        return self.lecture.tag ?? self.lecture.name
    }

}
