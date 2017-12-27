//
//  ScheduleService.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ScheduleService: Service {
    
    struct Auth: Hashable, Codable {
        enum Degree: String, Codable {
            case bachelor, diplom, master
        }
        
        let year: String
        let major: String
        let group: String
        let degree: Degree

        var hashValue: Int {
            return self.year.hashValue ^ self.major.hashValue ^ self.group.hashValue ^ self.degree.rawValue.hashValue
        }

        static func ==(lhs: ScheduleService.Auth, rhs: ScheduleService.Auth) -> Bool {
            return lhs.year == rhs.year && lhs.major == rhs.major && lhs.group == rhs.group && lhs.degree == rhs.degree
        }
    }

    struct Information: Codable, Equatable {
        let lectures: [Day: [AppLecture]]
        let semesters: [SemesterInformation]
        
        init(lectures: [Day: [Lecture]], semesters: [SemesterInformation], hidden: inout [Int: Bool], colors: inout [Int: UInt]) {
            var counter = 0
            self.lectures = lectures.mapValues({ Information.injectDomainLogic(lectures: $0, counter: &counter, hidden: &hidden, colors: &colors) })
            self.semesters = semesters
        }
        
        private static func injectDomainLogic(lectures: [Lecture], counter: inout Int, hidden: inout [Int: Bool], colors: inout [Int: UInt]) -> [AppLecture] {
            return lectures.map { l in
                let hash = l.fullHash()
                let savedHidden = hidden[hash] ?? false
                print("Name: \(l.name). Hidden: \(savedHidden)")
                let nameHash = l.name.hashValue
                let savedColor = colors[nameHash]
                let color = savedColor ?? UIColor.htw.scheduleColors[counter % UIColor.htw.scheduleColors.count].hex()
                if savedColor == nil {
                    counter += 1
                    colors[nameHash] = color
                }
                // TODO: Inject hidden as well! (get matching value from array)
                return AppLecture(lecture: l, color: color, hidden: savedHidden)
            }
        }
        
        private enum CodingKeys : CodingKey {
            case lectures, semesters
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.lectures = try values.decode(CodableDictionary.self, forKey: .lectures).decoded
            self.semesters = try values.decode([SemesterInformation].self, forKey: .semesters)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(CodableDictionary(self.lectures), forKey: .lectures)
            try container.encode(self.semesters, forKey: .semesters)
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
    
    private let persistenceService = PersistenceService()

    func load(parameters: Auth) -> Observable<Information> {
        if let cached = self.cachedInformation[parameters] {
            return Observable.just(cached)
        }

        let lecturesObservable = Lecture.get(network: self.network, year: parameters.year, major: parameters.major, group: parameters.group)
            .map(Lecture.groupByDay)
        var hidden = self.loadHidden()
        var colors = self.loadColors()

        let informationObservable = SemesterInformation.get(network: self.network)
        
        let cached = self.persistenceService.loadScheduleCache()
        let internetLoading: Observable<Information> = Observable.combineLatest(lecturesObservable, informationObservable) { [weak self] l, s in
            let information = Information(lectures: l, semesters: s, hidden: &hidden, colors: &colors)
            self?.saveHidden(hidden)
            self?.saveColors(colors)
            self?.cachedInformation[parameters] = information
            self?.persistenceService.save(information)
            return information
        }
        return Observable.merge(cached, internetLoading).distinctUntilChanged()
    }

    // MARK: - Hidden lectures
    
    private func loadHidden() -> [Int: Bool] {
        return self.persistenceService.loadHidden()
    }
    
    private func saveHidden(_ hidden: [Int: Bool]) {
        self.persistenceService.save(hidden)
    }
    
	// MARK: - Lecture Colors
		
    private func loadColors() -> [Int: UInt] {
        return self.persistenceService.loadScheduleColors()
    }
    
    private func saveColors(_ colors: [Int: UInt]) {
        self.persistenceService.save(colors)
    }
    
}

// MARK: - Dependency management

extension ScheduleService: HasSchedule {
    var scheduleService: ScheduleService { return self }
}
