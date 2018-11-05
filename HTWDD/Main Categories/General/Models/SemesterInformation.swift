//
//  SemesterInformation.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

struct SemesterInformation: Codable {
    private let year: Int
    private let type: String
    var semester: Semester {
        if self.type == "W" {
            return .winter(year: self.year)
        }
        return .summer(year: self.year)
    }
    
    let period: EventPeriod
    let freeDays: Set<Event>
    let lecturePeriod: EventPeriod
    let examsPeriod: EventPeriod
    let reregistration: EventPeriod
    
    enum CodingKeys: String, CodingKey {
        case year
        case type
        case period
        case freeDays
        case lecturePeriod
        case examsPeriod
        case reregistration
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.year = try container.decode(Int.self, forKey: .year)
        self.type = try container.decode(String.self, forKey: .type)
        self.period = try container.decode(EventPeriod.self, forKey: .period)
        
        let freeDays = try container.decode([Event].self, forKey: .freeDays)
        self.freeDays = Set(freeDays)
        
        self.lecturePeriod = try container.decode(EventPeriod.self, forKey: .lecturePeriod)
        self.examsPeriod = try container.decode(EventPeriod.self, forKey: .examsPeriod)
        self.reregistration = try container.decode(EventPeriod.self, forKey: .reregistration)
    }
}

extension SemesterInformation {
    static let url = "https://www2.htw-dresden.de/~app/API/semesterplan.json"
    
    static func get(network: Network) -> Observable<[SemesterInformation]> {
        return network.getArray(url: SemesterInformation.url)
    }
}

extension SemesterInformation {
    static func information(date: Date, input: [SemesterInformation]) -> SemesterInformation? {
        for e in input {
            if e.contains(date: date) {
                return e
            }
        }
        return nil
    }
    
    func contains(date: Date) -> Bool {
        guard let eventDate = EventDate(date: date) else {
            return false
        }
        return self.period.contains(date: eventDate)
    }
    
    func lecturesContains(date: Date) -> Bool {
        guard let eventDate = EventDate(date: date) else {
            return false
        }
        return self.lecturePeriod.contains(date: eventDate)
    }
    
    func freeDayContains(date: Date) -> Event? {
        guard let eventDate = EventDate(date: date) else {
            return nil
        }
        
        for d in self.freeDays {
            if d.period.contains(date: eventDate) {
                return d
            }
        }
        return nil
    }
}

extension SemesterInformation: Equatable {
    static func ==(lhs: SemesterInformation, rhs: SemesterInformation) -> Bool {
        return lhs.semester == rhs.semester
    }
}
