//
//  CanteenMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class CanteenMainVC: TableViewController {

    private let refreshControl = UIRefreshControl()

    private lazy var dataSource = CanteenDataSource(context: self.context)

    let context: HasCanteen
    init(context: HasCanteen) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    // MARK: - ViewController lifecycle

    override func initialSetup() {
        super.initialSetup()

        self.title = Loca.Canteen.title
        self.tabBarItem.image = #imageLiteral(resourceName: "Hamburger")

        self.dataSource.tableView = self.tableView
        self.dataSource.register(type: MealCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic

            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }

        self.reload()
    }

    @objc private func reload() {
        self.dataSource
            .load()
            .delay(0.5, scheduler: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .completed, .error(_):
                    self?.refreshControl.endRefreshing()
                default: break
                }
            }.disposed(by: self.rx_disposeBag)
    }

}
