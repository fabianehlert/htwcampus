//
//  ErrorCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

/// Use to display an error in the collection view.
class ErrorCollectionCell: CollectionViewCell {

    /// Setting the error String will replace the labels string with the given one.
    var error: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }

    private let label = UILabel()

    override func initialSetup() {
        self.contentView.backgroundColor = .red
        self.label.frame = self.contentView.bounds
        self.label.textColor = .white
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.label.numberOfLines = 0
        self.label.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(self.label)
    }

}

class ErrorSupplementaryView: CollectionReusableView {

    /// Setting the error String will replace the labels string with the given one.
    var error: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }

    private let label = UILabel()

    override func initialSetup() {
        self.backgroundColor = .red
        self.label.frame = self.bounds
        self.label.textColor = .white
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.label.numberOfLines = 0
        self.label.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(self.label)
    }

}

class ErrorTableCell: TableViewCell {
    /// Setting the error String will replace the labels string with the given one.
    var error: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }

    private let label = UILabel()

    override func initialSetup() {
        self.contentView.backgroundColor = .red
        self.label.frame = self.contentView.bounds
        self.label.textColor = .white
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.label.numberOfLines = 0
        self.label.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(self.label)
    }
}
