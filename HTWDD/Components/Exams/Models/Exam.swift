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
    enum ExamType: String, Codable {
        case s = "SP", m = "MP", a = "APL"
    }
    
    let title: String
    let type: ExamType
    let branch: String
    let examiner: String
    let rooms: [String]
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case type = "ExamType"
        case branch = "StudyBranch"
        case examiner = "Examiner"
        case rooms = "Rooms"
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
