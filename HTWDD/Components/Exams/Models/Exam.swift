//
//  Exam.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

struct Exam: Codable, Identifiable, Equatable {
    enum ExamType: Codable, Equatable {
        case s, m, a, other(String)
		
        init(from decoder: Decoder) throws {
            let content = try decoder.singleValueContainer().decode(String.self)
            switch content {
            case "SP": self = .s
            case "MP": self = .m
            case "APL": self = .a
            default: self = .other(content)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            let c: String
            switch self {
            case .s: c = "SP"
            case .m: c = "MP"
            case .a: c = "APL"
            case .other(let content): c = content
            }
            var container = encoder.singleValueContainer()
            try container.encode(c)
        }
        
		var displayName: String {
			switch self {
			case .s:
				return Loca.Exams.ExamType.written
			case .m:
				return Loca.Exams.ExamType.oral
			case .a:
				return Loca.Exams.ExamType.apl
            case .other(let c):
                return c
			}
		}
        
        static func ==(lhs: ExamType, rhs: ExamType) -> Bool {
            return lhs.displayName == rhs.displayName
        }
    }
    
    let title: String
    let type: ExamType
    let branch: String
    let examiner: String
    let rooms: [String]
    
    // TODO: This should be improved, just to show something
    let day: String
    let start: String
    let end: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case type = "ExamType"
        case branch = "StudyBranch"
        case examiner = "Examiner"
        case rooms = "Rooms"
        case day = "Day"
        case start = "StartTime"
        case end = "EndTime"
    }

    static func ==(lhs: Exam, rhs: Exam) -> Bool {
        return lhs.title == rhs.title && lhs.type == rhs.type && lhs.branch == rhs.branch && lhs.examiner == rhs.examiner && lhs.rooms == rhs.rooms
    }
    
    static let url = "https://www2.htw-dresden.de/~app/API/GetExams.php"
    
    static func get(network: Network, auth: ScheduleService.Auth) -> Observable<[Exam]> {
        let absc: String
        switch auth.degree {
        case .bachelor: absc = "B"
        case .diplom: absc = "D"
        case .master: absc = "M"
        }
        return network.getArray(url: url, params: [
            "StgJhr": auth.year,
            "Stg": auth.major,
            "AbSc": absc,
            "StgNr": auth.group
        ])
    }

}
