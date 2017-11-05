//
//  CollectionViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class CollectionViewController: ViewController {

    let collectionView: UICollectionView

    init(layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		self.collectionView.backgroundColor = .white
		super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.backgroundColor = UIColor.htw.veryLightGrey
        self.collectionView.frame = self.view.bounds
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.collectionView)

        self.collectionView.delegate = self
    }
    
    func itemWidth(collectionView: UICollectionView) -> CGFloat {
        let sectionInsets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout).map { $0.sectionInset.left + $0.sectionInset.right } ?? 0
        let width = collectionView.width - collectionView.contentInset.left - collectionView.contentInset.right - sectionInsets
        return width
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if self.collectionView.width < size.width {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }

}

extension CollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? Highlightable else {
            return
        }
        cell.highlight(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? Highlightable else {
            return
        }
        cell.unhighlight(animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {}
