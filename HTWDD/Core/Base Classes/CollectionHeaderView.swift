//
//  CollectionHeaderView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 01.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class CollectionHeaderView: CollectionReusableView, Identifiable {

    private let label = UILabel()

    var attributedTitle: NSAttributedString? {
        get {
            return self.label.attributedText
        }
        set {
            self.label.attributedText = newValue
        }
    }
    
    var titleInset: CGFloat = 12 {
        didSet {
            self.leading.constant = titleInset + self.htw.safeAreaInsets.left
            self.trailing.constant = -(titleInset + self.htw.safeAreaInsets.right)
            self.layoutIfNeeded()
        }
    }
    
    private var leading = NSLayoutConstraint()
    private var trailing = NSLayoutConstraint()
    
    // MARK: - Init
    
    override func initialSetup() {
        self.backgroundColor = .clear
        
        self.label.numberOfLines = 0
        self.label.textAlignment = .left
		self.label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.label)

        self.leading = self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: titleInset + self.htw.safeAreaInsets.left)
        self.trailing = self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(titleInset + self.htw.safeAreaInsets.right))
        
        NSLayoutConstraint.activate([
            self.leading,
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.trailing
        ])
	}
    
}
