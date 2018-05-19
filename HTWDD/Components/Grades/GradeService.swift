//
//  GradeService.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class GradeService: Service {

    enum Const {
        static let gradesCacheKey = "gradesCacheKey"
    }
    
    struct Auth: Hashable, Codable {
        let username: String
        let password: String

        var hashValue: Int {
            return self.username.hashValue ^ self.password.hashValue
        }

        static func ==(lhs: Auth, rhs: Auth) -> Bool {
            return lhs.username == rhs.username && lhs.password == rhs.password
        }
    }

    struct Information: Codable, Equatable {
        let semester: Semester
        let grades: [Grade]
        let average: Double
        
        init(semester: Semester, grades: [Grade]) {
            self.semester = semester
            self.grades = grades
            
            let reduced = self.grades.reduce((mark: 0.0,credits: 0.0), { r, e in
                guard let mark = e.mark else {
                    return r
                }
                return (r.0 + mark * e.credits, r.1 + e.credits)
            })
            if reduced.credits > 0 {
                self.average = reduced.mark / reduced.credits
            } else {
                self.average = 0
            }
        }
        
        static func ==(lhs: Information, rhs: Information) -> Bool {
            return lhs.semester == rhs.semester && lhs.grades == rhs.grades
        }
    }

    // MARK: - State
    private var cachedInformation = [Auth: [Information]]()
    private let persistenceService = PersistenceService()

    // MARK: - Loading

    private func loadCourses(network: Network) -> Observable<[Course]> {
        return Course.get(network: network)
    }

    private func loadGrades(network: Network, for course: Course) -> Observable<[Grade]> {
        return Grade.get(network: network, course: course)
    }

    func loadFromNetwork(_ auth: Auth) -> Observable<[Information]> {
        let network = Network(authenticator: Base(username: auth.username, password: auth.password))
        
        return loadCourses(network: network)
            .flatMap { (courses) -> Observable<[Information]> in
                let grades = courses.map { self.loadGrades(network: network, for: $0) }
                return Observable.combineLatest(grades)
                    .map { Array($0.joined()) }
                    .map(GradeService.groupAndOrderBySemester)
        }
    }
    
    func load(parameters: Auth) -> Observable<[Information]> {
        if let cached = self.cachedInformation[parameters] {
            return Observable.just(cached)
        }

        let loadFromNetwork = self.loadFromNetwork(parameters)
        let loadFromCache = self.persistenceService.loadGradesCache()
        
        return Observable.merge(loadFromNetwork, loadFromCache)
            .observeOn(MainScheduler.instance)
            .map { [weak self] semesters in
                self?.cachedInformation[parameters] = semesters
                self?.persistenceService.save(semesters)
                return semesters
        }
    }

    /// Groups and sorts a given array of grades by their semester.
    ///
    /// - Parameter grades: the array that should be sorted
    /// - Returns: array of semesters + their grades, already sorted by semester
    private static func groupAndOrderBySemester(grades: [Grade]) -> [Information] {

        var semesterHash = [Semester: [Grade]]()

        for grade in grades {
            semesterHash[grade.semester, or: []].append(grade)
        }

        for (semester, grades) in semesterHash {
            semesterHash[semester] = grades.sorted(by: { g1, g2 in
                return g1.text < g2.text
            })
        }

        // newest first
        return semesterHash.sorted {
            return $0.key > $1.key
        }.map(Information.init)
    }
    
    /// Calculates the overall average of the given semesters.
    ///
    /// - Parameter information: the loaded information to calculate the average from
    /// - Returns: the average of all grades weighted by credits
    static func calculateAverage(from information: [Information]) -> Double {
        var sumCredits = 0.0
        var sumGrade = 0.0
        
        for semester in information {
            for g in semester.grades {
                sumCredits += g.credits
                sumGrade += g.credits * (g.mark ?? 0)
            }
        }
        
        // Don't devide by zero!
        guard sumCredits > 0 else {
            return 0
        }
        
        return sumGrade / sumCredits
    }
    
    static func checkIfValid(auth: Auth, completion: @escaping (Bool) -> Void) {
        let service = GradeService()
        var disposable: Disposable?
        let callCompletionAndDispose: (Bool) -> Void = {
            completion($0)
            disposable?.dispose()
            disposable = nil
        }
        disposable = service.loadFromNetwork(auth)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                callCompletionAndDispose(true)
            }, onError: { _ in
                callCompletionAndDispose(false)
            })
        
    }

}

// MARK: - Dependency management

extension GradeService: HasGrade {
    var gradeService: GradeService { return self }
}
