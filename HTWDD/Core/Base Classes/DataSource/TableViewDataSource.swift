//
//  TableViewDataSource.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class TableViewDataSource: NSObject {

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

    weak var tableView: UITableView? {
        didSet {
            self.tableView?.register(ErrorTableCell.self, forCellReuseIdentifier: Const.errorIdentifier)
            self.tableView?.dataSource = self
        }
    }

    fileprivate enum Const {
        static let errorIdentifier = "Error"
    }

    fileprivate typealias Configuration = (Any, UITableViewCell, IndexPath) -> Void
    fileprivate var configurations = [String: Configuration]()

//    fileprivate typealias SupplementaryViewConfiguration = (UICollectionReusableView, IndexPath) -> Void
//    fileprivate var supplementaryConfigurations = [String: SupplementaryViewConfiguration]()
//    fileprivate var supplementaryKinds = [SupplementaryKind: String]()

    func register<CellType: UITableViewCell>(type: CellType.Type) where CellType: Cell {

        assert(self.tableView != nil)
        let identifier = type.ViewModelType.ModelType.identifier
        self.tableView?.register(type, forCellReuseIdentifier: identifier)

        self.configurations[identifier] = { model, cell, indexPath in
            (cell as! CellType).update(viewModel: CellType.ViewModelType(model: model as! CellType.ViewModelType.ModelType))
        }
    }

//    func registerSupplementary<S: CollectionReusableView>(_ supplementary: S.Type, kind: SupplementaryKind, config: @escaping (S, IndexPath) -> Void) where S: Identifiable {
//
//        assert(self.tableView != nil)
//        let identifier = S.identifier
//        self.tableView?.register(supplementary, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: identifier)
//
//        self.supplementaryKinds[kind] = identifier
//
//        self.supplementaryConfigurations[identifier] = { view, indexPath in
//            config(view as! S, indexPath)
//        }
//    }

    func invalidate() {
        self.tableView?.reloadData()
    }

}

extension TableViewDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let model = self.item(at: indexPath) else {
            return errorCell(tableView: tableView, indexPath: indexPath, error: "nil model")
        }

        let identifier = model.identifier

        guard let config = self.configurations[identifier] else {
            return errorCell(tableView: tableView, indexPath: indexPath, error: "not configured (\(identifier))")
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        config(model, cell, indexPath)
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        guard let mappedKind = SupplementaryKind(rawValue: kind) else {
//            return self.errorSupplementaryView(collectionView: collectionView, indexPath: indexPath, error: "unknown kind: \(kind)")
//        }
//
//        guard let identifier = self.supplementaryKinds[mappedKind] else {
//            return self.errorSupplementaryView(collectionView: collectionView, indexPath: indexPath, error: "not configured \(kind)")
//        }
//
//        guard let config = self.supplementaryConfigurations[identifier] else {
//            return self.errorSupplementaryView(collectionView: collectionView, indexPath: indexPath, error: "not configured")
//        }
//
//        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
//        config(view, indexPath)
//
//        return view
//    }

    private func errorCell(tableView: UITableView, indexPath: IndexPath, error: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.errorIdentifier, for: indexPath) as! ErrorTableCell
        cell.error = error
        return cell
    }

//    private func errorSupplementaryView(collectionView: UICollectionView, indexPath: IndexPath, error: String) -> UICollectionReusableView {
//        let view = collectionView.dequeueReusableSupplementaryView(ofKind: Const.errorIdentifier, withReuseIdentifier: Const.errorIdentifier, for: indexPath) as! ErrorSupplementaryView
//        view.error = error
//        return view
//    }

}
