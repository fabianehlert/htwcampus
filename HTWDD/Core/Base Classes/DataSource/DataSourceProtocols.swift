//
//  DataSourceProtocols.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

protocol Identifiable {}
extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }

    var identifier: String {
        return type(of: self).identifier
    }
}

protocol ViewModel {
    associatedtype ModelType: Identifiable
    init(model: ModelType)
}

protocol Cell: class {
    associatedtype ViewModelType: ViewModel
    func update(viewModel: ViewModelType)
}

protocol SupplementaryView: class, Identifiable {
    associatedtype Data
    func update(data: Data)
}

protocol Highlightable {
    func highlight(animated: Bool)
    func unhighlight(animated: Bool)
}
