//
//  CollectionViewDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

enum SupplementaryKind: String {
    case header = "UICollectionElementKindSectionHeader"
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
    
    private typealias Action = (Any, IndexPath) -> Void
    private var actions = [String: Action]()
    
    private typealias HeightCalculation = (Any, CGFloat) -> CGFloat
    private var heightCalculations = [String: HeightCalculation]()
    
    func register<CellType: UICollectionViewCell>(type: CellType.Type, configure: @escaping (CellType, CellType.ViewModelType, IndexPath) -> Void = {_, _, _ in }) where CellType: HeightCalculator {
        assert(self.collectionView != nil)
        
        let identifier = type.ViewModelType.ModelType.identifier
        self.heightCalculations[identifier] = { model, width in
            let viewModel = CellType.ViewModelType(model: model as! CellType.ViewModelType.ModelType)
            return CellType.height(for: width, viewModel: viewModel)
        }
        return self.registerCell(type: type, configure: configure)
    }
    
    func register<CellType: UICollectionViewCell>(type: CellType.Type, configure: @escaping (CellType, CellType.ViewModelType, IndexPath) -> Void = {_, _, _ in }) where CellType: Cell {

        assert(self.collectionView != nil)
        
        self.registerCell(type: type, configure: configure)
    }
    
    private func registerCell<CellType: UICollectionViewCell>(type: CellType.Type, configure: @escaping (CellType, CellType.ViewModelType, IndexPath) -> Void) where CellType: Cell {
        let identifier = type.ViewModelType.ModelType.identifier
        self.collectionView?.register(type, forCellWithReuseIdentifier: identifier)
        
        self.configurations[identifier] = { model, cell, indexPath in
            let viewModel = CellType.ViewModelType(model: model as! CellType.ViewModelType.ModelType)
            (cell as! CellType).update(viewModel: viewModel)
            configure(cell as! CellType, viewModel, indexPath)
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
    
    func registerAction<CellType: UICollectionViewCell>(cell: CellType.Type, action: @escaping (CellType.ViewModelType.ModelType, IndexPath) -> Void) where CellType: Cell {
        assert(self.collectionView != nil)
        
        let identifier = CellType.ViewModelType.ModelType.identifier
        self.actions[identifier] = { model, indexPath in
            action(model as! CellType.ViewModelType.ModelType, indexPath)
        }
    }
    
    func runAction(at indexPath: IndexPath) {
        guard let model = self.item(at: indexPath) else {
            return
        }
        guard let action = self.actions[model.identifier] else {
            return
        }
        action(model, indexPath)
    }

    func invalidate() {
        self.collectionView?.reloadData()
    }
    
    func height(width: CGFloat, indexPath: IndexPath) -> CGFloat? {
        guard let model = self.item(at: indexPath) else {
            return nil
        }
        
        let identifier = model.identifier
        guard let heightBlock = self.heightCalculations[identifier] else {
            return nil
        }
        return heightBlock(model, width)
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
