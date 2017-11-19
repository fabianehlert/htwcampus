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
	
	// MARK: - Init
	
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
        
        self.dataSource.registerAction(cell: MealCell.self) { [weak self] meal, indexPath in
            let vm = MealViewModel(model: meal)
            let dc = CanteenDetailViewController(viewModel: vm)
            self?.presentDetail(dc, animated: true)
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
        
        DispatchQueue.main.async {
            self.register3DTouch()
        }
    }

    override func noResultsViewConfiguration() -> NoResultsView.Configuration? {
        return .init(title: Loca.Canteen.noResults.title, message: Loca.Canteen.noResults.message, image: nil)
    }
    
    @objc private func reload() {
        self.dataSource.load()
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
    
    private func register3DTouch() {
        guard self.traitCollection.forceTouchCapability == .available else {
            return
        }
        self.registerForPreviewing(with: self, sourceView: self.collectionView)
    }
    
    fileprivate func presentDetail(_ controller: UIViewController, animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let nc = controller.inNavigationController()
            nc.modalPresentationStyle = .formSheet
            self.present(nc, animated: animated, completion: nil)
        } else {
            self.navigationController?.pushViewController(controller, animated: animated)
        }
    }
    
    // MARK: - UICollectionViewDelegate(FlowLayout) stuff
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.itemWidth(collectionView: collectionView)
        let height: CGFloat = 120
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataSource.runAction(at: indexPath)
    }
    
}

// MARK: - UIViewControllerPreviewingDelegate
extension CanteenMainVC: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard
            let indexPath = self.collectionView.indexPathForItem(at: location),
            let item = self.dataSource.item(at: indexPath) as? Meal
        else {
                return nil
        }
        
        if let cell = self.collectionView.cellForItem(at: indexPath) {
            previewingContext.sourceRect = cell.frame
        }
        
        return CanteenDetailViewController(viewModel: MealViewModel(model: item))
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.presentDetail(viewControllerToCommit, animated: false)
    }
}
