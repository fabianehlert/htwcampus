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

    var auth: GradeService.Auth? {
        set { self.dataSource.auth = newValue }
        get { return nil }
    }

    private lazy var dataSource = GradeDataSource(context: self.context)

    private let refreshControl = UIRefreshControl()

    private var selectedIndexPath: IndexPath?

    let context: HasGrade
    init(context: HasGrade) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initialSetup() {
        self.title = Loca.Grades.title
		self.tabBarItem.image = #imageLiteral(resourceName: "Grade")
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

        self.tableView.separatorStyle = .none

        self.dataSource.tableView = self.tableView
        self.dataSource.register(type: GradeCell.self)
        self.reload()
    }

	// MARK: - Private

	@objc private func reload() {
		self.dataSource.load()
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

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedIndexPath == indexPath {
            self.selectedIndexPath = nil
            tableView.reloadRows(at: [indexPath], with: .none)
            return
        }

        let currentSelected = self.selectedIndexPath
        self.selectedIndexPath = indexPath
        let indexPaths = [indexPath] + (currentSelected.map { [$0] } ?? [])
        tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.none)

        let oldCell = currentSelected.flatMap(tableView.cellForRow) as? GradeCell
        oldCell?.updatedExpanded(false)

        let newCell = tableView.cellForRow(at: indexPath) as? GradeCell
        newCell?.updatedExpanded(true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndexPath == indexPath {
            return GradeCell.Const.expandedHeight
        }
        return GradeCell.Const.collapsedHeight
    }
}
