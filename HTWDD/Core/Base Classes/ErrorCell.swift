//
//  ErrorCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

/// Use to display an error in the collection view.
class ErrorCell: UICollectionViewCell {

    /// Setting the error String will replace the labels string with the given one.
    var error: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private let label = UILabel()

    private func setup() {
        self.label.frame = self.contentView.bounds
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.label.numberOfLines = 0
        self.label.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(self.label)
    }

}
