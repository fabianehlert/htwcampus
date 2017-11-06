//
//  CanteenMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class CanteenMainVC: CollectionViewController {

    enum Const {
        static let margin: CGFloat = 15
    }
    
    private let refreshControl = UIRefreshControl()

    private lazy var dataSource = CanteenDataSource(context: self.context)

    let context: HasCanteen
    init(context: HasCanteen) {
        self.context = context
        super.init()
        self.collectionView.contentInset = UIEdgeInsets(top: Const.margin, left: Const.margin, bottom: Const.margin, right: Const.margin)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    // MARK: - ViewController lifecycle

    override func initialSetup() {
        super.initialSetup()

        self.title = Loca.Canteen.title
        self.tabBarItem.image = #imageLiteral(resourceName: "Canteen")

        self.dataSource.collectionView = self.collectionView
        self.dataSource.register(type: MealCell.self)
        self.dataSource.registerSupplementary(CollectionHeaderView.self, kind: .header) { [weak self] view, indexPath in
            let date = NSAttributedString(string: self?.dataSource.date.string(format: "d. MMMM").uppercased() ?? "",
                                          attributes: [.foregroundColor: UIColor.htw.textBody, .font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
            let title = NSAttributedString(string: self?.dataSource.titleFor(section: indexPath.section) ?? "",
                                                  attributes: [.foregroundColor: UIColor.htw.textHeadline, .font: UIFont.systemFont(ofSize: 22, weight: .bold)])
            
            let attributedTitle = NSMutableAttributedString()
            attributedTitle.append(date)
            attributedTitle.append(NSAttributedString(string: "\n"))
            attributedTitle.append(title)
            
            view.attributedTitle = attributedTitle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
		self.refreshControl.tintColor = .white
		
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic

            self.collectionView.refreshControl = self.refreshControl
        } else {
            self.collectionView.addSubview(self.refreshControl)
        }

        self.dataSource.loading
            .delay(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                if value {
                    self?.refreshControl.beginRefreshing()
                } else {
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: self.rx_disposeBag)
        
        self.reload()
    }

    @objc private func reload() {
        self.dataSource.load()
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.itemWidth(collectionView: collectionView)
        return CGSize(width: width, height: 140)
    }
    
}
