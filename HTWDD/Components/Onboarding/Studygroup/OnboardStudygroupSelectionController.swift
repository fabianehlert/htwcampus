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
    private let visualEffectView = UIVisualEffectView(effect: nil)
    private let selection: (Data?) -> Void
	
	@available(iOS 10.0, *)
	private lazy var animator: UIViewPropertyAnimator = {
		let a = UIViewPropertyAnimator(duration: 0.4, curve: .linear, animations: {
			self.visualEffectView.effect = UIBlurEffect(style: .extraLight)
		})
		return a
	}()
	
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
		
        self.visualEffectView.isUserInteractionEnabled = true
		self.visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		self.view.insertSubview(self.visualEffectView, belowSubview: self.collectionView)
		
        NSLayoutConstraint.activate([
			self.visualEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.visualEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.visualEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			self.visualEffectView.topAnchor.constraint(equalTo: self.view.topAnchor),

            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor)
		])
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancel))
		self.collectionView.backgroundView = UIView()
		self.collectionView.backgroundView?.addGestureRecognizer(tapGesture)
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
		if #available(iOS 11.0, *) {
			self.animator.pausesOnCompletion = true
		}
        self.animator.isReversed = direction == .dismiss
        self.animator.startAnimation()
		
		if direction == .present {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.animator.pauseAnimation()
            }
        }

		UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: {
			self.collectionView.alpha = direction == .present ? 1 : 0
			self.collectionView.contentOffset.y += direction == .present ? 150 : -150
		}, completion: { completed in
			if direction == .dismiss {
                self.animator.stopAnimation(false)
                self.animator.finishAnimation(at: .current)
            }
			completion(completed)
		})
    }
    
}
