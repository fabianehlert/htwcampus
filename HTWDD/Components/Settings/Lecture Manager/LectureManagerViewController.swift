//
//  LectureManagerViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 22.12.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class LectureManagerViewController: TableViewController {
    
    var auth: ScheduleService.Auth?
    
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
        self.tableView.separatorColor = UIColor.htw.lightGrey
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
