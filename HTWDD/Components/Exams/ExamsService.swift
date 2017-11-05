//
//  ExamsService.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class ExamsService: Service {
    
    struct Information: Codable, Equatable {
        let exams: [Exam]
        
        static func ==(lhs: Information, rhs: Information) -> Bool {
            return lhs.exams == rhs.exams
        }
    }
    
    private let network = Network()
    private var cachedInformation = [ScheduleService.Auth: Information]()
    private let persistenceService = PersistenceService()
    
    func load(parameters: ScheduleService.Auth) -> Observable<Information> {
        if let cached = self.cachedInformation[parameters] {
            return Observable.just(cached)
        }
        
        let internet: Observable<Information> = Exam.get(network: self.network, auth: parameters)
            .map { [weak self] exams in
                let information = Information(exams: exams)
                self?.cachedInformation[parameters] = information
                return information
        }
        let cached = self.persistenceService.loadExamsCache()
        
        return Observable.merge(internet, cached).distinctUntilChanged()
    }
}

extension ExamsService: HasExams {
    var examService: ExamsService {
        return self
    }
}
