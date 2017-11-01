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

    private var _auth: GradeService.Auth?
    var auth: GradeService.Auth? {
        set {
            self._auth = newValue
        }
        get {
            // don't export sensitive information!
            return nil
        }
    }
    private let service: GradeService

    init(context: HasGrade) {
        self.service = context.gradeService
    }

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

    func load() -> Observable<()> {
        guard let auth = self._auth else {
            Log.info("Can't load grades if no authentication is provided. Abort…")
            return Observable.just(())
        }

        return self.service
            .load(parameters: auth)
            .debug()
            .map { [weak self] semesters in
            self?.semesters = semesters
        }
    }

    override func titleFor(section: Int) -> String? {
        let semester = self.semesters[section].semester
        return semester.localized
    }

}
