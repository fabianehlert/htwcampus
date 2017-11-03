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
    let shortTitle: String
    let longTitle: String
    let subtitle: String
    
    let begin: String
    let end: String

    var professor: String?

	let room: String?

    init(model: Lecture) {
        self.shortTitle = model.tag ?? model.name
        self.longTitle = model.name
        
        self.begin = Loca.Schedule.Cell.time(model.begin.hour ?? 0, model.begin.minute ?? 0)
        self.end = Loca.Schedule.Cell.time(model.end.hour ?? 0, model.end.minute ?? 0)

        self.professor = nil
        if let prof = model.professor {
            if prof.hasSuffix(", ") {
                self.professor = String(prof.dropLast(2))
            } else {
                self.professor = prof
            }
        }
        
        self.room = model.rooms.first
		
		// TODO: Localise. And it's also kinda hacky.
		var t = model.type
		if t.hasPrefix("V") {
			t = "Vorlesung"
		} else if t.hasPrefix("P") {
			t = "Praktikum"
		} else if t.hasPrefix("Ü") {
			t = "Übung"
		}
		
		self.subtitle = t
    }
}
