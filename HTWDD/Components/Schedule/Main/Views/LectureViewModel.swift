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
	let color: UInt
	
	let shortTitle: String
    let longTitle: String
    let type: String
	let rawType: String
    let tag: String
    
    let begin: String
    let end: String
    let time: String

    let professor: String?
    let day: Day
    let week: Week

	let room: String?

    init(model appLecture: AppLecture) {
        let model = appLecture.lecture
        
		self.color = appLecture.color
		
        self.shortTitle = model.tag ?? model.name
        self.longTitle = model.name
        
        self.begin = Loca.Schedule.Cell.time(model.begin.hour ?? 0, model.begin.minute ?? 0)
        self.end = Loca.Schedule.Cell.time(model.end.hour ?? 0, model.end.minute ?? 0)
        self.time = "\(self.begin) – \(self.end)"

        if let prof = model.professor {
            if prof.hasSuffix(", ") {
                self.professor = String(prof.dropLast(2))
            } else {
                self.professor = prof
            }
        } else {
            self.professor = nil
        }
        
        self.day = model.day
        self.week = model.week
        
        if model.rooms.isEmpty {
            self.room = Loca.Schedule.noRoom
        } else if model.rooms.count == 1 {
            self.room = model.rooms.first
        } else {
            self.room = model.rooms.joined(separator: ", ")
        }

		self.type = LectureViewModel.determineType(model.type)
		self.rawType = model.type
        self.tag = model.tag ?? ""
    }
	
	static func determineType(_ type: String) -> String {
		if type.hasPrefix("V") {
			return Loca.Schedule.LectureType.lecture
		} else if type.hasPrefix("Ü") {
			return Loca.Schedule.LectureType.exercise
		} else if type.hasPrefix("P") {
			return Loca.Schedule.LectureType.practical
		}
		return type
	}
}
