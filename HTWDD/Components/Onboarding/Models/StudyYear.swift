//
//  StudyYear.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

struct StudyYear: Decodable {
    
    let studyYear: Int
    let studyCourses: [StudyCourse]
    
    static func get(network: Network) -> Observable<[StudyYear]> {
        return network.getArray(url: "https://rubu2.rz.htw-dresden.de/API/v0/studyGroups.php")
    }
}

struct StudyCourse: Decodable {
    
    let studyCourse: String
    let name: String
    let studyGroups: [StudyGroup]
    
    private enum CodingKeys: String, CodingKey {
        case studyCourse
        case name
        case studyGroups
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let number = try? container.decode(Int.self, forKey: .studyCourse) {
            self.studyCourse = string(length: 3, number: number)
        } else if let str = try? container.decode(String.self, forKey: .studyCourse) {
            self.studyCourse = str
        } else {
            throw NSError()
        }
        
        self.name = try container.decode(String.self, forKey: .name)
        self.studyGroups = try container.decode([StudyGroup].self, forKey: .studyGroups)
    }
    
}

struct StudyGroup: Decodable {
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
    let degree: Degree
    
    private enum CodingKeys: String, CodingKey {
        case studyGroup
        case name
        case grade
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StudyGroup.CodingKeys.self)
        if let number = try? container.decode(Int.self, forKey: .studyGroup) {
            self.studyGroup = string(length: 2, number: number)
        } else if let str = try? container.decode(String.self, forKey: .studyGroup) {
            self.studyGroup = str
        } else {
            throw NSError()
        }
        
        self.name = try container.decode(String.self, forKey: .name)
        let grade = try container.decode(Int.self, forKey: .grade)
        guard let degree = Degree(grade: grade) else {
            throw NSError()
        }
        self.degree = degree
    }
    
}

private func string(length: Int, number: Int) -> String {
    var str = number.description
    while str.count < 2 {
        str = "0" + str
    }
    return str
}
