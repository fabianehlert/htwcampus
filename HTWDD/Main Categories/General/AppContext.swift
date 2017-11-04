//
//  AppContext.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 17.09.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

class User {

}

protocol HasSchedule {
    var scheduleService: ScheduleService { get }
}

protocol HasExams {
	var examService: ExamsService { get }
}

protocol HasGrade {
    var gradeService: GradeService { get }
}

protocol HasCanteen {
    var canteenService: CanteenService { get }
}

protocol HasSettings {
	var settingsService: SettingsService { get }
}

class AppContext: HasSchedule, HasGrade, HasCanteen, HasExams, HasSettings {

    let scheduleService = ScheduleService()
	let examService = ExamsService()
	let gradeService = GradeService()
    let canteenService = CanteenService()
	let settingsService = SettingsService()
	
}
