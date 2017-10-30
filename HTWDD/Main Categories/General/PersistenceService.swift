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

    // MARK: - Save

    func save(_ schedule: ScheduleService.Auth) {
        self.save(object: schedule, key: Const.scheduleKey)
    }

    func save(_ grade: GradeService.Auth) {
        self.save(object: grade, key: Const.gradesKey)
    }

    private func save<T: Encodable>(object: T, key: String) {
        guard let data = try? JSONEncoder().encode(object) else { return }
        try? self.keychain.set(data, key: key)
    }

}
