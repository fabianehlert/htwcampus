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
        static let appGroup = "group.htw-dresden.ios"

        static let scheduleKey = "htw-dresden.schedule.auth"
        static let gradesKey = "htw-dresden.grades.auth"
        
        static let scheduleCacheKey = "htw-dresden.schedule.cache"
        static let gradesCacheKey = "htw-dresden.grades.cache"
    }

    struct Response {
        var schedule: ScheduleService.Auth?
        var grades: GradeService.Auth?
    }

    private let keychain = Keychain(accessGroup: Const.appGroup)

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

    // MARK: - Save

    func save(_ schedule: ScheduleService.Auth) {
        self.save(object: schedule, key: Const.scheduleKey)
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
    }

    func removeSchedule() {
        self.remove(key: Const.scheduleKey)
    }

    func removeGrade() {
        self.remove(key: Const.gradesKey)
    }
    
    func removeScheduleCache() {
        self.remove(key: Const.scheduleCacheKey)
    }
    
    func removeGradesCache() {
        self.remove(key: Const.gradesCacheKey)
    }

    private func remove(key: String) {
        try? self.keychain.remove(key)
    }

}
