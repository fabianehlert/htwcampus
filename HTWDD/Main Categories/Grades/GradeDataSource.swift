//
//  GradeDataSource.swift
//  HTWDD
//
//  Created by Kilian Költzsch on 12.04.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class GradeDataSource: TableViewDataSource {
    let network: Network
    var semesters = [(semester: Semester, grades: [Grade])]() {
        didSet {
            self.tableView?.reloadData()
        }
    }

    var disposeBag = DisposeBag()

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.semesters.count
    }

    override func numberOfItems(in section: Int) -> Int {
        return self.semesters[section].grades.count
    }

    override func item(at index: IndexPath) -> Identifiable? {
        return self.semesters[index.section].grades[index.row]
    }

    private func loadCourses() -> Observable<[Course]> {
        return Course.get(network: self.network)
    }

    private func loadGrades(for course: Course) -> Observable<[Grade]> {
        return Grade.get(network: self.network, course: course)
    }

    func load() {
        self.disposeBag = DisposeBag()

        loadCourses()
            .flatMap { (courses) -> Observable<[(Semester, [Grade])]> in
                let grades = courses.map(self.loadGrades)
                return Observable.combineLatest(grades)
                    .map { Array($0.joined()) }
                    .map(Grade.groupAndOrderBySemester)
            }
            .debug()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] semesters in
                self?.semesters = semesters
                }, onError: { error in
                    Log.error(error)
            })
            .addDisposableTo(self.disposeBag)
    }

    init(username: String, password: String) {
        self.network = Network(authenticator: Base(username: username, password: password))
        super.init()
    }
}
