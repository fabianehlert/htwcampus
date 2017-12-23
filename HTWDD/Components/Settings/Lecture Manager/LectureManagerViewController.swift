//
//  LectureManagerViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 22.12.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class LectureManagerViewController: TableViewController {
    
    var auth: ScheduleService.Auth?
    
    private lazy var dataSource = GenericBasicTableViewDataSource(data: self.lectures)
    private var lectures = [(String?, [AppLecture])]()
    
    // MARK: - Init
    
    init(auth: ScheduleService.Auth?) {
        super.init(style: .grouped)
        self.auth = auth
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - ViewController lifecycle
    
    override func initialSetup() {
        super.initialSetup()
        self.title = Loca.Schedule.Settings.Hide.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScheduleService().load(parameters: auth!).subscribe(onNext: { info in
            self.lectures = info.lectures.map({
                return ($0.key.stringValue, $0.value)
            })
            self.dataSource = GenericBasicTableViewDataSource(data: self.lectures)
            self.dataSource.tableView = self.tableView
            self.dataSource.register(type: SwitchCell.self)
            self.dataSource.invalidate()
        }).disposed(by: self.rx_disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
