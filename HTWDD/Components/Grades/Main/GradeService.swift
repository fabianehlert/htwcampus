//
//  GradeService.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class GradeService {
    
    struct Information {
        let semester: Semester
        let grades: [Grade]
    }

    // MARK: - State
    private var semesters = [Information]()
    private let network: Network

    // MARK: - Initializer

    init(username: String, password: String) {
        self.network = Network(authenticator: Base(username: username, password: password))
    }

    private func loadCourses() -> Observable<[Course]> {
        return Course.get(network: self.network)
    }

    private func loadGrades(for course: Course) -> Observable<[Grade]> {
        return Grade.get(network: self.network, course: course)
    }

    func load() -> Observable<[Information]> {
        return loadCourses()
            .flatMap { (courses) -> Observable<[Information]> in
                let grades = courses.map(self.loadGrades)
                return Observable.combineLatest(grades)
                    .map { Array($0.joined()) }
                    .map(GradeService.groupAndOrderBySemester)
            }
            .observeOn(MainScheduler.instance)
            .map { [weak self] semesters in
                self?.semesters = semesters
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

        // newest first
        return semesterHash.sorted {
            return $0.key > $1.key
        }.map(Information.init)
    }

}
