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
    
    var title: String? {
        get {
            return self.label.text
        }
        set {
            self.label.text = newValue?.uppercased()
        }
    }
    
    // MARK: - Init
    
    override func initialSetup() {
        self.backgroundColor = .clear
        
        self.label.frame = self.bounds
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.label.font = .systemFont(ofSize: 16, weight: .semibold)
        self.label.textColor = UIColor.htw.mediumGrey
        self.label.textAlignment = .center
        self.addSubview(self.label)
    }

}
