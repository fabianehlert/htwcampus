//
//  LectureViewModel.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 24.09.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

extension Lecture: Identifiable {}

struct LectureViewModel: ViewModel {
    let title: String
    let subtitle: String
	let room: String?
    let timeString: String

    init(model: Lecture) {
        self.title = model.tag ?? model.name
        self.subtitle = model.type
        self.room = model.rooms.first
        let begin = Loca.Schedule.Cell.time(model.begin.hour ?? 0, model.begin.minute ?? 0)
        let end = Loca.Schedule.Cell.time(model.end.hour ?? 0, model.end.minute ?? 0)
        self.timeString = "\(begin) - \(end)"
    }
}
