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
            self.load().subscribe().disposed(by: self.rx_disposeBag)
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

    @discardableResult
    func load() -> Observable<()> {
        guard let auth = self._auth else {
            Log.info("Can't load grades if no authentication is provided. Abort…")
            return Observable.just(())
        }

        return Observable.create { observer in
            let disposable = self.service
                .load(parameters: auth)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] semesters in
                    self?.semesters = semesters
                    observer.onNext(())
                    observer.onCompleted()
            })
            return Disposables.create {
                disposable.dispose()
            }
        }
    }

    func semester(`for` section: Int) -> Semester {
        return self.semesters[section].semester
    }

}
