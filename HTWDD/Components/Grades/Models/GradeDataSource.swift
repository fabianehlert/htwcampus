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
    private let service: GradeService
    private var semesters = [GradeService.Information]() {
        didSet {
            self.tableView?.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.semesters.count
    }

    override func numberOfItems(in section: Int) -> Int {
        return self.semesters[section].grades.count
    }

    override func item(at index: IndexPath) -> Identifiable? {
        return self.semesters[index.section].grades[index.row]
    }

    func load() -> Observable<[GradeService.Information]> {
        return self.service.load().map { [weak self] semesters in
            self?.semesters = semesters
            return semesters
        }
    }

    override func titleFor(section: Int) -> String? {
        let semester = self.semesters[section].semester
        return semester.localized
    }

    init(username: String, password: String) {
        self.service = GradeService(username: username, password: password)
        super.init()
    }
}
