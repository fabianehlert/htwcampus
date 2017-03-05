//
//  CollectionViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class CollectionViewController: ViewController {

    var collectionView: UICollectionView

    init(layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.backgroundColor = .white
        self.collectionView.frame = self.view.bounds
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.collectionView)

        self.collectionView.delegate = self
    }

}

extension CollectionViewController: UICollectionViewDelegate {

}
