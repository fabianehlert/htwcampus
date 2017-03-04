//
//  CollectionViewDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class CollectionViewDataSource: NSObject {

    // MARK: Override those methods in subclass!

    func numberOfSections() -> Int {
        preconditionFailure("\(#function) needs to be overriden in subclass (\(self))!")
    }

    func numberOfItems(in section: Int) -> Int {
        preconditionFailure("\(#function) needs to be overriden in subclass (\(self))!")
    }

    func item(at index: IndexPath) -> Identifiable? {
        preconditionFailure("\(#function) needs to be overriden in subclass (\(self))!")
    }

    weak var collectionView: UICollectionView? {
        didSet {
            self.collectionView?.register(ErrorCell.self, forCellWithReuseIdentifier: Const.errorIdentifier)
            self.collectionView?.dataSource = self
        }
    }

    fileprivate enum Const {
        static let errorIdentifier = "Error"
    }

    fileprivate typealias Configuration = (Any, UICollectionViewCell, IndexPath) -> Void
    fileprivate var configurations = [String: Configuration]()

    func register<CellType: UICollectionViewCell>(type: CellType.Type) where CellType: Cell {

        assert(self.collectionView != nil)
        let identifier = type.ViewModelType.ModelType.identifier
        self.collectionView?.register(type, forCellWithReuseIdentifier: identifier)

        self.configurations[identifier] = { model, cell, indexPath in
            (cell as! CellType).update(viewModel: CellType.ViewModelType(model: model as! CellType.ViewModelType.ModelType))
        }
    }

    func invalidate() {
        self.collectionView?.reloadData()
    }

}

extension CollectionViewDataSource: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let model = self.item(at: indexPath) else {
            return errorCell(collectionView: collectionView, indexPath: indexPath, error: "nil model")
        }

        let identifier = model.identifier

        guard let config = self.configurations[identifier] else {
            return errorCell(collectionView: collectionView, indexPath: indexPath, error: "not configured (\(identifier))")
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        config(model, cell, indexPath)
        return cell
    }

    private func errorCell(collectionView: UICollectionView, indexPath: IndexPath, error: String) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.errorIdentifier, for: indexPath) as! ErrorCell
        cell.error = error
        return cell
    }

}
