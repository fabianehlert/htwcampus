//
//  PersistenceService.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import KeychainAccess

class PersistenceService: Service {

    private enum Const {
        static let service = "de.htw-dresden.ios"
		static let accessGroup = "3E4PGPNR47.keychain-group"
		
        static let scheduleKey = "htw-dresden.schedule.auth"
        static let scheduleHiddenKey = "htw-dresden.schedule.hidden"
        static let scheduleColorsKey = "htw-dresden.schedule.colors"
        static let gradesKey = "htw-dresden.grades.auth"
        
        static let scheduleCacheKey = "htw-dresden.schedule.cache"
        static let gradesCacheKey = "htw-dresden.grades.cache"
        static let examsCacheKey = "htw-dresden.exams.cache"
    }

    struct Response {
        var schedule: ScheduleService.Auth?
        var grades: GradeService.Auth?
    }

    private let keychain = Keychain(service: Const.service, accessGroup: Const.accessGroup)

    // MARK: - Load

    func load(parameters: () = ()) -> Observable<Response> {
        let res = Response(schedule: self.load(type: ScheduleService.Auth.self, key: Const.scheduleKey),
                           grades: self.load(type: GradeService.Auth.self, key: Const.gradesKey))
        return Observable.just(res)
    }

    private func load<T: Codable>(type: T.Type, key: String) -> T? {
        let savedData = (try? keychain.getData(key)).flatMap(identity)

        guard let data = savedData else {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func loadHidden() -> [Int: Bool] {
        return self.load(type: [Int: Bool].self, key: Const.scheduleHiddenKey) ?? [:]
    }
    
    func loadScheduleColors() -> [Int: UInt] {
        return self.load(type: [Int: UInt].self, key: Const.scheduleColorsKey) ?? [:]
    }
    
    func loadScheduleCache() -> Observable<ScheduleService.Information> {
        guard let saved = self.load(type: ScheduleService.Information.self, key: Const.scheduleCacheKey) else {
            return Observable.empty()
        }
        return Observable.just(saved)
    }
    
    func loadGradesCache() -> Observable<[GradeService.Information]> {
        guard let saved = self.load(type: [GradeService.Information].self, key: Const.gradesCacheKey) else {
            return Observable.empty()
        }
        return Observable.just(saved)
    }
    
    func loadExamsCache() -> Observable<ExamsService.Information> {
        guard let saved = self.load(type: ExamsService.Information.self, key: Const.examsCacheKey) else {
            return Observable.empty()
        }
        return Observable.just(saved)
    }

    // MARK: - Save

    func save(_ schedule: ScheduleService.Auth) {
        self.save(object: schedule, key: Const.scheduleKey)
    }
    
    func save(_ hidden: [Int: Bool]) {
        var all = self.loadHidden()
        all.merge(hidden, uniquingKeysWith: { $0 || $1 })
        self.save(object: all, key: Const.scheduleHiddenKey)
    }
    
    func save(_ colors: [Int: UInt]) {
        self.save(object: colors, key: Const.scheduleColorsKey)
    }

    func save(_ grade: GradeService.Auth) {
        self.save(object: grade, key: Const.gradesKey)
    }
    
    func save(_ grades: [GradeService.Information]) {
        self.save(objects: grades, key: Const.gradesCacheKey)
    }
    
    func save(_ lectures: ScheduleService.Information) {
        self.save(object: lectures, key: Const.scheduleCacheKey)
    }
    
    func save(_ exams: ExamsService.Information) {
        self.save(object: exams, key: Const.examsCacheKey)
    }

    private func save<T: Encodable>(object: T, key: String) {
        guard let data = try? JSONEncoder().encode(object) else { return }
        try? self.keychain.set(data, key: key)
    }
    
    private func save<T: Encodable>(objects: [T], key: String) {
        guard let data = try? JSONEncoder().encode(objects) else { return }
        try? self.keychain.set(data, key: key)
    }

    // MARK: - Remove

    func clear() {
        self.removeGrade()
        self.removeSchedule()
        self.removeScheduleHidden()
        self.removeScheduleColors()
        self.removeGradesCache()
        self.removeScheduleCache()
    }

    func removeSchedule() {
        self.remove(key: Const.scheduleKey)
    }
    
    func removeScheduleHidden() {
        self.remove(key: Const.scheduleHiddenKey)
    }
    
    func removeScheduleColors() {
        self.remove(key: Const.scheduleColorsKey)
    }

    func removeGrade() {
        self.remove(key: Const.gradesKey)
    }
    
    func removeScheduleCache() {
        self.remove(key: Const.scheduleCacheKey)
    }
    
    func removeExamsCache() {
        self.remove(key: Const.examsCacheKey)
    }
    
    func removeGradesCache() {
        self.remove(key: Const.gradesCacheKey)
    }

    private func remove(key: String) {
        try? self.keychain.remove(key)
    }

}
