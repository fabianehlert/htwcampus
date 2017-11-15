//
//  ScheduleBaseVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 31.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ScheduleBaseVC: CollectionViewController {

    let dataSource: ScheduleDataSource

    private var lastSelectedIndexPath: IndexPath?

    let startHour: CGFloat

    var auth: ScheduleService.Auth? {
        get { return nil }
        set { self.dataSource.auth = newValue }
    }

    init(configuration: ScheduleDataSource.Configuration, layout: UICollectionViewLayout, startHour: CGFloat) {
        self.dataSource = ScheduleDataSource(configuration: configuration)
        self.startHour = startHour
        super.init(layout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // DataSource
        self.dataSource.collectionView = self.collectionView
        
        let todayButton = UIBarButtonItem(title: Loca.Schedule.today, style: .plain, target: self, action: #selector(jumpToToday))
        self.navigationItem.rightBarButtonItem = todayButton

        self.dataSource.load()

		DispatchQueue.main.async {
			self.register3DTouch()
		}
        
        NotificationCenter.default.rx
            .notification(.UIApplicationWillEnterForeground)
            .subscribe(onNext: { [weak self] _ in
                self?.dataSource.invalidate()
                self?.jumpToToday()
            })
            .disposed(by: self.rx_disposeBag)
    }

    override func noResultsViewConfiguration() -> NoResultsView.Configuration? {
        return .init(title: Loca.Schedule.noResults.title, message: Loca.Schedule.noResults.message, image: nil)
    }
    
    // MARK: - Private

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

    @objc
    func jumpToToday() {
        let left = CGPoint(x: -self.collectionView.contentInset.left, y: self.collectionView.contentOffset.y)
        self.collectionView.setContentOffset(left, animated: true)
    }

}

// MARK: - CollectionViewDelegate
extension ScheduleBaseVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource.lecture(at: indexPath) else {
            Log.error("Expected to get a lecture for indexPath \(indexPath), but got nothing from dataSource..")
            return
        }
        self.lastSelectedIndexPath = indexPath
        let detail = ScheduleDetailVC(lecture: item)
        self.presentDetail(detail, animated: true)
    }
}

// MARK: - UIViewControllerPreviewingDelegate
extension ScheduleBaseVC: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard
            let indexPath = self.collectionView.indexPathForItem(at: location),
            let item = self.dataSource.lecture(at: indexPath)
            else {
                return nil
        }

        if let cell = self.collectionView.cellForItem(at: indexPath) {
            previewingContext.sourceRect = cell.frame
        }

        self.lastSelectedIndexPath = indexPath
        return ScheduleDetailVC(lecture: item)
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.presentDetail(viewControllerToCommit, animated: false)
    }
}

// MARK: - AnimatedViewControllerTransitionDataSource
extension ScheduleBaseVC: AnimatedViewControllerTransitionDataSource {
    func viewForTransition(_ transition: AnimatedViewControllerTransition) -> UIView? {
        return self.lastSelectedIndexPath.flatMap(self.collectionView.cellForItem(at:))
    }
}
