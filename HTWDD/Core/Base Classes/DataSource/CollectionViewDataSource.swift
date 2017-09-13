//
//  CollectionViewDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

enum SupplementaryKind: String {
    case header
    case description
}

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
            self.collectionView?.register(ErrorCollectionCell.self, forCellWithReuseIdentifier: Const.errorIdentifier)
            self.collectionView?.register(ErrorSupplementaryView.self, forSupplementaryViewOfKind: Const.errorIdentifier, withReuseIdentifier: Const.errorIdentifier)
            self.collectionView?.dataSource = self
        }
    }

    fileprivate enum Const {
        static let errorIdentifier = "Error"
    }

    fileprivate typealias Configuration = (Any, UICollectionViewCell, IndexPath) -> Void
    fileprivate var configurations = [String: Configuration]()

    fileprivate typealias SupplementaryViewConfiguration = (UICollectionReusableView, IndexPath) -> Void
    fileprivate var supplementaryConfigurations = [String: SupplementaryViewConfiguration]()
    fileprivate var supplementaryKinds = [SupplementaryKind: String]()

    func register<CellType: UICollectionViewCell>(type: CellType.Type) where CellType: Cell {

        assert(self.collectionView != nil)
        let identifier = type.ViewModelType.ModelType.identifier
        self.collectionView?.register(type, forCellWithReuseIdentifier: identifier)

        self.configurations[identifier] = { model, cell, indexPath in
            (cell as! CellType).update(viewModel: CellType.ViewModelType(model: model as! CellType.ViewModelType.ModelType))
        }
    }

    func registerSupplementary<S: CollectionReusableView>(_ supplementary: S.Type, kind: SupplementaryKind, config: @escaping (S, IndexPath) -> Void) where S: Identifiable {

        assert(self.collectionView != nil)
        let identifier = S.identifier
        self.collectionView?.register(supplementary, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: identifier)

        self.supplementaryKinds[kind] = identifier

        self.supplementaryConfigurations[identifier] = { view, indexPath in
            config(view as! S, indexPath)
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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let mappedKind = SupplementaryKind(rawValue: kind) else {
            return self.errorSupplementaryView(collectionView: collectionView, indexPath: indexPath, error: "unknown kind: \(kind)")
        }

        guard let identifier = self.supplementaryKinds[mappedKind] else {
            return self.errorSupplementaryView(collectionView: collectionView, indexPath: indexPath, error: "not configured \(kind)")
        }

        guard let config = self.supplementaryConfigurations[identifier] else {
            return self.errorSupplementaryView(collectionView: collectionView, indexPath: indexPath, error: "not configured")
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        config(view, indexPath)

        return view
    }

    private func errorCell(collectionView: UICollectionView, indexPath: IndexPath, error: String) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.errorIdentifier, for: indexPath) as! ErrorCollectionCell
        cell.error = error
        return cell
    }

    private func errorSupplementaryView(collectionView: UICollectionView, indexPath: IndexPath, error: String) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: Const.errorIdentifier, withReuseIdentifier: Const.errorIdentifier, for: indexPath) as! ErrorSupplementaryView
        view.error = error
        return view
    }

}
