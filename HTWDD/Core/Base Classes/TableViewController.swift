//
//  TableViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23.05.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class TableViewController: ViewController {
    
    let tableView: UITableView

    init(style: UITableViewStyle = .plain) {
        self.tableView = UITableView(frame: .zero, style: style)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tableView = UITableView(frame: .zero, style: .plain)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = .white
        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.tableView)

        self.tableView.delegate = self
    }

}

extension TableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
