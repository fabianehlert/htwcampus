//
//  GradeMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class GradeMainVC: CollectionViewController {

    enum Const {
        static let margin: CGFloat = 10
    }
    
    var auth: GradeService.Auth? {
        set { self.dataSource.auth = newValue }
        get { return nil }
    }

    private lazy var dataSource = GradeDataSource(context: self.context)

    private let refreshControl = UIRefreshControl()

    private var selectedIndexPath: IndexPath?

    private let layout = UICollectionViewFlowLayout()
    
    let context: HasGrade
    init(context: HasGrade) {
        self.context = context
        super.init(layout: self.layout)
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

            self.collectionView.refreshControl = self.refreshControl
        } else {
            self.collectionView.addSubview(self.refreshControl)
        }

        self.dataSource.collectionView = self.collectionView
        self.dataSource.register(type: GradeCell.self) { [weak self] cell, _, indexPath in
            if self?.selectedIndexPath == indexPath {
                cell.updatedExpanded(true)
            }
        }
        self.dataSource.registerSupplementary(CollectionHeaderView.self, kind: .header) { [weak self] view, indexPath in
            let semesterTitle = self?.dataSource.semester(for: indexPath.section).localized
            view.title = semesterTitle
        }
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

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedIndexPath == indexPath {
            self.selectedIndexPath = nil
            collectionView.reloadItems(at: [indexPath])
            return
        }
        
        let currentSelected = self.selectedIndexPath
        self.selectedIndexPath = indexPath
        let indexPaths = [indexPath] + (currentSelected.map { [$0] } ?? [])
        collectionView.reloadItems(at: indexPaths)
        
        let oldCell = currentSelected.flatMap(collectionView.cellForItem) as? GradeCell
        oldCell?.updatedExpanded(false)
        
        let newCell = collectionView.cellForItem(at: indexPath) as? GradeCell
        newCell?.updatedExpanded(true)
    }

}

extension GradeMainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.width - Const.margin * 2
        let height: CGFloat
        if self.selectedIndexPath == indexPath {
            height = GradeCell.Const.expandedHeight
        } else {
            height = GradeCell.Const.collapsedHeight
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.width - Const.margin*2, height: 60)
    }
    
}
