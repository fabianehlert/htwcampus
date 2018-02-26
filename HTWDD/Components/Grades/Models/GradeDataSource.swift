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

    private var average = GradeAverage(average: 0.0, credits: 0)
    private var semesters = [GradeService.Information]() {
        didSet {
            let average = GradeService.calculateAverage(from: self.semesters)
            let credits = self.semesters.reduce(0) { res, inf in
                return res + inf.grades.reduce(0, { res, grade in
                    return res + Int(grade.credits)
                })
            }
            self.average = GradeAverage(average: average, credits: credits)
            self.collectionView?.reloadData()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let semestersCount = self.semesters.count
        // we have one section more for the average
        return semestersCount > 0 ? semestersCount + 1 : 0
    }

    override func numberOfItems(in section: Int) -> Int {
        guard section > 0 else {
            // grades average
            return 1
        }
        return self.semesters[safe: section - 1]?.grades.count ?? 0
    }

    override func item(at index: IndexPath) -> Identifiable? {
        guard index.section > 0 else {
            return self.average
        }
        return self.semesters[safe: index.section - 1]?.grades[index.row]
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
 
    func information(`for` section: Int) -> GradeService.Information? {
        guard section > 0 else {
            return nil
        }
        return self.semesters[section - 1]
    }

}
