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
	
	var type: String {
		let t = self.lecture.type
		
		// TODO: Localise. And it's also kinda hacky.
		if t.hasPrefix("V") {
			return "Vorlesung"
		} else if t.hasPrefix("P") {
			return "Praktikum"
		} else if t.hasPrefix("Ü") {
			return "Übung"
		}
		
		return t
	}
	
	var tag: String {
		return self.lecture.tag ?? ""
	}
	
	var title: String {
		return self.lecture.name
	}
	
	var rooms: [String] {
		return self.lecture.rooms
	}
	
	var begin: String? {
		return Loca.Schedule.Cell.time(self.lecture.begin.hour ?? 0, self.lecture.begin.minute ?? 0)
	}
	
	var end: String? {
		return Loca.Schedule.Cell.time(self.lecture.end.hour ?? 0, self.lecture.end.minute ?? 0)
	}
	
	var professor: String? {
        if let prof = self.lecture.professor {
            if prof.hasSuffix(", ") {
                return String(prof.dropLast(2))
            } else {
                return prof
            }
        }
		return self.lecture.professor
	}
	
	var day: Day {
		return self.lecture.day
	}
	
	var week: Week {
		return self.lecture.week
	}

}
