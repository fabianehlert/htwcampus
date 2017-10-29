//
//  ScheduleService.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class ScheduleService {

    struct Auth {
        let year: String
        let major: String
        let group: String
    }

    struct Information {
        let lectures: [Day: [Lecture]]
        let semesters: [SemesterInformation]
    }

    private let network = Network()

    func load(auth: Auth) -> Observable<Information> {
        let lecturesObservable = Lecture.get(network: self.network, year: auth.year, major: auth.major, group: auth.group)
            .map(Lecture.groupByDay)

        let informationObservable = SemesterInformation.get(network: self.network)

        return Observable.combineLatest(lecturesObservable, informationObservable) { l, s in
            Information(lectures: l, semesters: s)
        }
    }

}
