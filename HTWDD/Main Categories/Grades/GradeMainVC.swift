//
//  GradeMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit

class GradeMainVC: TableViewController {

    let dataSource = GradeDataSource(username: "", password: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource.tableView = self.tableView
        self.dataSource.register(type: GradeCell.self)
        self.dataSource.load()
    }

}
