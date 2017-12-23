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
            self.lectures = info.lectures.sorted { $0.key.rawValue < $1.key.rawValue }.map({
                return ($0.key.name, $0.value)
            })
            self.configure()
        }).disposed(by: self.rx_disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private
    
    private func configure() {
        self.dataSource = GenericBasicTableViewDataSource(data: self.lectures)
        self.dataSource?.tableView = self.tableView
        self.dataSource?.register(type: SwitchCell.self)
        self.dataSource?.invalidate()
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
    }

}
