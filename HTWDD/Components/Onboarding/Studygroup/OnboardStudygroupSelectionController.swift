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
    static let collectionViewHeight: CGFloat = 300
    static let margin: CGFloat = 15
}

class OnboardStudygroupSelectionController<Data: Identifiable>: CollectionViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    private let layout = CollectionViewFlowLayout()
    private let dataSource: GenericBasicCollectionViewDataSource<Data>
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
            controller.modalPresentationStyle = .overCurrentContext
            controller.present(selectionController, animated: true, completion: nil)
            return Disposables.create {
                selectionController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - View Controller Lifecyle
    
    override func initialSetup() {
        super.initialSetup()
        
        self.dataSource.collectionView = self.collectionView
        self.dataSource.register(type: OnboardingStudygroupSelectionYearCell.self)
        self.dataSource.register(type: OnboardingStudygroupSelectionCourseCell.self)
        self.dataSource.register(type: OnboardingStudygroupSelectionGroupCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.contentInset = UIEdgeInsets(top: self.view.height - Const.collectionViewHeight, left: Const.margin, bottom: Const.margin, right: Const.margin)
        self.layout.itemSize = CGSize(width: self.itemWidth(collectionView: self.collectionView), height: 60)
        self.collectionView.backgroundColor = .clear
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(visualEffectView)
        self.view.sendSubview(toBack: visualEffectView)
        
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            
            visualEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            visualEffectView.topAnchor.constraint(equalTo: self.view.topAnchor)
            ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancel))
        tapGesture.delegate = self
        self.collectionView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func cancel(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: {
            self.selection(nil)
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataSource.data(at: indexPath)
        self.dismiss(animated: true, completion: {
            self.selection(item)
        })
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(type(of: gestureRecognizer.view))
        print(gestureRecognizer.location(in: self.collectionView))
        
        return false
    }
    
}
