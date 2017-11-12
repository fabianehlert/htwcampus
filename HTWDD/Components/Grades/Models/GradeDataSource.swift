//
//  GradeDataSource.swift
//  HTWDD
//
//  Created by Kilian Költzsch on 12.04.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class GradeDataSource: CollectionViewDataSource {

    private var _auth: GradeService.Auth? {
        didSet {
            guard self._auth != nil else {
                self.semesters = []
                return
            }
            self.load()
        }
    }
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
    private let disposeBag = DisposeBag()
    private let loadingCount = Variable(0)
    
    lazy var loading = self.loadingCount
        .asObservable()
        .map({ $0 > 0 })
        .observeOn(MainScheduler.instance)
    
    init(context: HasGrade) {
        self.service = context.gradeService
    }

    private var semesters = [GradeService.Information]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.semesters.count
    }

    override func numberOfItems(in section: Int) -> Int {
        return self.semesters[section].grades.count
    }

    override func item(at index: IndexPath) -> Identifiable? {
        return self.semesters[index.section].grades[index.row]
    }

    func load() {
        self.loadingCount.value += 1
        guard let auth = self._auth else {
            Log.info("Can't load grades if no authentication is provided. Abort…")
            self.loadingCount.value -= 1
            return
        }

        self.service
            .load(parameters: auth)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] semesters in
                    self?.semesters = semesters
                    self?.loadingCount.value -= 1
                }, onError: { [weak self] _ in
                    self?.loadingCount.value -= 1
                })
            .disposed(by: self.disposeBag)
    }

    func semester(`for` section: Int) -> Semester {
        return self.semesters[section].semester
    }

}
