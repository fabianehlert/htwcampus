//
//  CanteenMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import OpenMensaKit

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

        Canteen.get(withID: 80) { result in
            guard let canteen = result.success else {
                return
            }
            print(canteen.address)
            print(canteen.city)
            print(canteen.coordinate)
            canteen.getMeals(forDay: Date().byAdding(days: 1), completion: { result in
                guard let meals = result.success else {
                    return
                }
                dump(meals)
                self.refreshControl.endRefreshing()
            })
        }

    }

}
