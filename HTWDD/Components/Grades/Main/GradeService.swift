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

    struct Information {
        let semester: Semester
        let grades: [Grade]
    }

    // MARK: - State
    private var cachedInformation = [Auth: [Information]]()

    // MARK: - Loading

    private func loadCourses(network: Network) -> Observable<[Course]> {
        return Course.get(network: network)
    }

    private func loadGrades(network: Network, for course: Course) -> Observable<[Grade]> {
        return Grade.get(network: network, course: course)
    }

    func load(parameters: Auth) -> Observable<[Information]> {
        if let cached = self.cachedInformation[parameters] {
            return Observable.just(cached)
        }

        let network = Network(authenticator: Base(username: parameters.username, password: parameters.password))

        return loadCourses(network: network)
            .flatMap { (courses) -> Observable<[Information]> in
                let grades = courses.map { self.loadGrades(network: network, for: $0) }
                return Observable.combineLatest(grades)
                    .map { Array($0.joined()) }
                    .map(GradeService.groupAndOrderBySemester)
            }
            .observeOn(MainScheduler.instance)
            .map { [weak self] semesters in
                self?.cachedInformation[parameters] = semesters
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
                guard let date1 = g1.date else {
                    return false
                }
                guard let date2 = g2.date else {
                    return true
                }
                return date1 > date2
            })
        }

        // newest first
        return semesterHash.sorted {
            return $0.key > $1.key
        }.map(Information.init)
    }

}

// MARK: - Dependency management

extension GradeService: HasGrade {
    var gradeService: GradeService { return self }
}
