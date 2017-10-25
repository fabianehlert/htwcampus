//
//  GradeMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class GradeMainVC: TableViewController {

    let dataSource = GradeDataSource(username: "", password: "")

    private let refreshControl = UIRefreshControl()

    override func initialSetup() {
        self.title = Loca.gradesTitle
		self.tabBarItem.image = UIImage(named: "Grade")
    }

	// MARK: - ViewController lifecycle

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

        self.dataSource.tableView = self.tableView
        self.dataSource.register(type: GradeCell.self)
        self.reload()
    }

	// MARK: - Private

	@objc private func reload() {
		self.dataSource.load()
			.take(1)
			.delay(0.5, scheduler: MainScheduler.instance)
			.subscribe(onNext: { [weak self] _ in
				self?.refreshControl.endRefreshing()
				}, onError: { [weak self] err in
					self?.refreshControl.endRefreshing()
					self?.showAlert(error: err)
			}).disposed(by: self.rx_disposeBag)
	}

	// MARK: - Actions

    private func showAlert(error: Error) {
        let alert = UIAlertController(title: "Fehler", message: "Some failure in loading: \(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
