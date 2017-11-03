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
    
    // MARK: - Init
    
    override func initialSetup() {
        self.backgroundColor = .clear
        
        self.label.numberOfLines = 0
        self.label.textAlignment = .left
		self.label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.label)
		
		NSLayoutConstraint.activate([
			self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 21 + self.htw.safeAreaInsets.left),
			self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
			self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 21 + self.htw.safeAreaInsets.right)
		])
	}

}
