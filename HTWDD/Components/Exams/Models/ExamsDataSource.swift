//
//  ExamsDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class ExamsDataSource: CollectionViewDataSource {
    
    private var data = [Exam]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var auth: ScheduleService.Auth? {
        didSet {
            guard self.auth != nil else {
                self.data = []
                return
            }
            self.load()
        }
    }
    
    private let service: ExamsService
    private let disposeBag = DisposeBag()
    init(context: HasExams) {
        self.service = context.examsService
    }
    
    override func numberOfSections() -> Int {
        return self.data.isEmpty ? 0 : 1
    }
    
    override func numberOfItems(in section: Int) -> Int {
        return self.data.count
    }
    
    override func item(at index: IndexPath) -> Identifiable? {
        return self.data[safe: index.item]
    }
    
    private let loadingCount = Variable(0)
    
    lazy var loading = self.loadingCount
                            .asObservable()
                            .map({ $0 > 0 })
                            .observeOn(MainScheduler.instance)
    
    func load() {
        self.loadingCount.value += 1
        guard let auth = self.auth else {
            Log.error("Can't load exams without authentication!")
            self.loadingCount.value -= 1
            return
        }
        
        self.service
            .load(parameters: auth)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] information in
                self?.data = information.exams
                self?.loadingCount.value -= 1
            }, onError: { [weak self] err in
                self?.loadingCount.value -= 1
            })
            .disposed(by: self.disposeBag)
    }
    
}
