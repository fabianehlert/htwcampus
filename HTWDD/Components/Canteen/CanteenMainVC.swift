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

    // MARK: - ViewController lifecycle

    override func initialSetup() {
        super.initialSetup()

        self.title = Loca.Canteen.title
        self.tabBarItem.image = #imageLiteral(resourceName: "Hamburger")
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
    }

    @objc private func reload() {
        dump(Date().byAdding(days: -6).components)
        Canteen.get(id: .reichenbachstrasse)
            .debug()
            .flatMap { $0.getMeals(date: Date().byAdding(days: -6)) }
            .debug()
            .subscribe(onNext: { meals in meals.forEach({ print($0.imageUrl?.absoluteString ?? "") }) })
            .disposed(by: self.rx_disposeBag)
        self.refreshControl.endRefreshing()
    }

}
