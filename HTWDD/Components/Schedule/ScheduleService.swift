//
//  ScheduleService.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class ScheduleService: Service {

    struct Auth: Hashable, Codable {
        let year: String
        let major: String
        let group: String

        var hashValue: Int {
            return self.year.hashValue ^ self.major.hashValue ^ self.group.hashValue
        }

        static func ==(lhs: ScheduleService.Auth, rhs: ScheduleService.Auth) -> Bool {
            return lhs.year == rhs.year && lhs.major == rhs.major && lhs.group == rhs.group
        }
    }

    struct Information: Codable, Equatable {
        let lectures: [Day: [Lecture]]
        let semesters: [SemesterInformation]
        
        init(lectures: [Day: [Lecture]], semesters: [SemesterInformation]) {
            self.lectures = lectures
            self.semesters = semesters
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.lectures = try values.decode(CodableDictionary.self, forKey: .lectures).decoded
            self.semesters = try values.decode([SemesterInformation.self], forKey: .semesters)
        }
        
        static func ==(lhs: Information, rhs: Information) -> Bool {
            guard lhs.lectures.count == rhs.lectures.count else {
                return false
            }
            let allSame = lhs.lectures.reduce(true) { p, n -> Bool in
                guard let rhsHas = rhs.lectures[n.key] else {
                    return false
                }
                return p && rhsHas == n.value
            }
            return allSame && lhs.semesters == rhs.semesters
        }
    }

    private let network = Network()

    private var cachedInformation = [Auth: Information]()

    func load(parameters: Auth) -> Observable<Information> {
        if let cached = self.cachedInformation[parameters] {
            return Observable.just(cached)
        }

        let lecturesObservable = Lecture.get(network: self.network, year: parameters.year, major: parameters.major, group: parameters.group)
            .map(Lecture.groupByDay)

        let informationObservable = SemesterInformation.get(network: self.network)

        return Observable.combineLatest(lecturesObservable, informationObservable) { [weak self] l, s in
            let information = Information(lectures: l, semesters: s)
            self?.cachedInformation[parameters] = information
            return information
        }.distinctUntilChanged()
    }
    
    private func loadFromCache() -> Information {
        
    }

}

// MARK: - Dependency management

extension ScheduleService: HasSchedule {
    var scheduleService: ScheduleService { return self }
}
