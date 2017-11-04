//
//  StudyYear.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

struct StudyYear: Codable {
    
    let studyYear: Int
    let studyCourses: [StudyCourse]
    
    static func get(network: Network) -> Observable<StudyYear> {
        return network.get(url: "https://rubu2.rz.htw-dresden.de/API/v0/studyGroups.php")
    }
}

struct StudyCourse: Codable {
    
    let studyCourse: String
    let name: String
    let studyGroups: [StudyGroup]
    
}

struct StudyGroup: Codable {
    enum Degree {
        case bachelor, diplom, master
        init?(grade: Int) {
            switch grade {
            case 0, 2: self = .diplom
            case 5, 6: self = .bachelor
            case 7, 8: self = .master
            default: return nil
            }
        }
    }
    
    let studyGroup: String
    let name: String
    let grade: Int
    var degree: Degree? {
        return Degree(grade: self.grade)
    }
}
