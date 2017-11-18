//
//  BadgeLabel.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 06.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit.UILabel

class BadgeLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		self.clipsToBounds = true
		self.textAlignment = .center
    }
    
    override var intrinsicContentSize: CGSize {
        let sup = super.intrinsicContentSize
		let innerMargin: CGFloat = 2
        return CGSize(width: sup.width + innerMargin * 6, height: sup.height + innerMargin * 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 3
    }
    
}
