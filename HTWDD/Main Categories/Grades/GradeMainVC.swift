//
//  GradeMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit

class GradeMainVC: ViewController {

    let tableView = UITableView()
    let dataSource = GradeDataSource(username: "", password: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.view.addSubview(self.tableView)
        self.dataSource.tableView = self.tableView
        self.dataSource.register(type: GradeCell.self)
        self.dataSource.load()
    }

}
