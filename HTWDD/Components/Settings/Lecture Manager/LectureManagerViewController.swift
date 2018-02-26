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
    
    var onFinish: (() -> Void)?
    
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
        
        guard let auth = auth else { return }
        // TODO: Take multiple??
        ScheduleService().load(parameters: auth).subscribe(onNext: { info in
            self.lectures = info.lectures.sorted { $0.key.rawValue < $1.key.rawValue }.map {
                return ($0.key.name, $0.value.sorted { $0.lecture.begin < $1.lecture.end })
            }
            self.configure()
        }).disposed(by: self.rx_disposeBag)
        
        self.lectures.forEach {
            $0.1.forEach { _ in
                // print("\($0.lecture.name) --> \($0.hidden)")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Also called on Tab change
        self.onFinish?()
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private
    
    private func configure() {
        self.dataSource = GenericBasicTableViewDataSource(data: self.lectures)
        self.dataSource?.tableView = self.tableView
        self.dataSource?.register(type: SwitchCell.self, configure: { cell, _, indexPath in
            cell.onStatusChange = { [weak self] on in
                if let lecture = self?.lectures[indexPath.section].1[indexPath.row] {
                    PersistenceService().save([lecture.lecture.fullHash(): !on])
                    
                    // TODO: Reload dataSource to apply changes. Otherwise it´d be UI only
                }
            }
        })
        self.dataSource?.invalidate()
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
    }

}
