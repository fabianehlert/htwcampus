//
//  TableViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23.05.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class TableViewController: ViewController {
    
    var dataSource: TableViewDataSource?
    
    let tableView: UITableView

    init(style: UITableView.Style = .plain) {
        self.tableView = UITableView(frame: .zero, style: style)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tableView = UITableView(frame: .zero, style: .plain)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.htw.veryLightGrey
        self.tableView.separatorColor = UIColor.htw.lightGrey
        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.add(self.tableView)

        self.tableView.delegate = self
    }

}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = self.dataSource?.titleFor(section: section) else { return 0 }
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let x = tableView.layoutMargins.left
        
        let label = UILabel(frame: CGRect(x: x, y: 35, width: tableView.width - 2*x, height: 20))
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.htw.grey
        label.text = self.dataSource?.titleFor(section: section)?.uppercased()
        
        let container = UIView(frame: .zero)
        container.add(label)
        
        return container
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
