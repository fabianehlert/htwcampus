//
//  ExamsMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class ExamsMainVC: CollectionViewController {
    
    enum Const {
        static let margin: CGFloat = 15
    }
    
    var auth: ScheduleService.Auth? {
        didSet {
            self.dataSource.auth = self.auth
        }
    }
    
    private let dataSource: ExamsDataSource

	// MARK: - Init
	
    init(context: HasExams) {
        self.dataSource = ExamsDataSource(context: context)
        super.init()
        self.dataSource.collectionView = self.collectionView
        self.collectionView.contentInset = UIEdgeInsets(top: Const.margin, left: Const.margin, bottom: Const.margin, right: Const.margin)
        
        self.dataSource.register(type: ExamsCell.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialSetup() {
        super.initialSetup()
        
        self.title = Loca.Exams.title
		self.tabBarItem.image = #imageLiteral(resourceName: "Exams")
    }
	
	// MARK: - ViewController lifecycle
	
    private let refreshControl = UIRefreshControl()
    
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
        
        let loading = self.dataSource.loading.filter { $0 == true }
        let notLoading = self.dataSource.loading.filter { $0 != true }
        
        loading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.setLoading(true)
            })
            .disposed(by: self.rx_disposeBag)
        
        notLoading
            .delay(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.setLoading(false)
            })
            .disposed(by: self.rx_disposeBag)
        
        self.reload()
	}
    
    override func noResultsViewConfiguration() -> NoResultsView.Configuration? {
        return .init(title: Loca.Exams.noResults.title, message: Loca.Exams.noResults.message, image: nil)
    }
    
    @objc
    func reload() {
        self.dataSource.load()
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
}

extension ExamsMainVC {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.itemWidth(collectionView: collectionView)
        return CGSize(width: width, height: 80)
    }
}

extension ExamsMainVC: TabbarChildViewController {
    func tabbarControllerDidSelectAlreadyActiveChild() {
        self.collectionView.setContentOffset(CGPoint(x: self.collectionView.contentOffset.x, y: -self.view.htw.safeAreaInsets.top), animated: true)
    }
}
