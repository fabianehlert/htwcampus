//
//  OnboardStudygroupSelectionController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

private enum Const {
    static let itemHeight: CGFloat = 80
    static let margin: CGFloat = 15
}

class OnboardStudygroupSelectionController<Data: Identifiable>: CollectionViewController, AnimatedViewControllerTransitionAnimator {
    
    // MARK: - Properties
    
    private let layout = CollectionViewFlowLayout()
    private let dataSource: GenericBasicCollectionViewDataSource<Data>
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    private let selection: (Data?) -> Void
    
    // MARK: - Init
    
    init(data: [Data], selection: @escaping (Data?) -> Void) {
        self.dataSource = GenericBasicCollectionViewDataSource(data: data)
        self.selection = selection
        super.init(layout: self.layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Observable API
    
    static func show(controller: UIViewController, data: [Data]) -> Observable<Data> {
        return Observable.create { observer in
            let selectionController = OnboardStudygroupSelectionController(data: data) { item in
                guard let item = item else {
                    return observer.onCompleted()
                }
                return observer.onNext(item)
            }
            selectionController.modalPresentationStyle = .overCurrentContext
            selectionController.transition = AnimatedViewControllerTransition(duration: 0.4, back: controller, front: selectionController)
            controller.present(selectionController, animated: true, completion: nil)
            return Disposables.create {
                selectionController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - View Controller Lifecyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func initialSetup() {
        super.initialSetup()
        
        self.dataSource.collectionView = self.collectionView
        self.dataSource.register(type: OnboardingStudygroupSelectionYearCell.self)
        self.dataSource.register(type: OnboardingStudygroupSelectionCourseCell.self)
        self.dataSource.register(type: OnboardingStudygroupSelectionGroupCell.self)
    }
    
    private var collectionViewHeight: CGFloat {
        return min(520.0, CGFloat(self.dataSource.numberOfItems(in: 0)) * (Const.margin + Const.itemHeight) + Const.margin)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.collectionView.contentInset = UIEdgeInsets(top: 0,
														left: Const.margin,
														bottom: Const.margin,
														right: Const.margin)

        self.layout.itemSize = CGSize(width: self.itemWidth(collectionView: self.collectionView), height: Const.itemHeight)
        self.collectionView.backgroundColor = .clear
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .clear
		self.view.alpha = 0
        
        self.visualEffectView.isUserInteractionEnabled = true
        self.collectionView.backgroundView = self.visualEffectView
        
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor)
		])
		
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancel))
        self.visualEffectView.addGestureRecognizer(tapGesture)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let top = (self.view.height - self.collectionView.contentSize.height - (self.view.htw.safeAreaInsets.bottom + 54))
		self.collectionView.contentInset = UIEdgeInsets(top: max(44, top),
														left: Const.margin,
														bottom: Const.margin,
														right: Const.margin)
	}
	
    @objc
    func cancel(gesture: UITapGestureRecognizer) {
        self.selection(nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataSource.data(at: indexPath)
        self.selection(item)
        self.dismiss(animated: true, completion: nil)
    }
    
    func animate(source: CGRect, sourceView: UIView?, duration: TimeInterval, direction: Direction, completion: @escaping (Bool) -> Void) {
        self.visualEffectView.effect = direction == .present ? nil : UIBlurEffect(style: .extraLight)
        let startY = (self.view.height - self.collectionViewHeight) * -1
        self.collectionView.contentOffset.y = direction == .present ? startY - 150 : startY
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: [.curveEaseIn], animations: {
            self.visualEffectView.effect = direction == .present ? UIBlurEffect(style: .extraLight) : nil
			self.view.alpha = direction == .present ? 1 : 0
            self.collectionView.contentOffset.y = direction == .present ? startY : startY - 150
            
        }, completion: completion)
        
    }
    
}
