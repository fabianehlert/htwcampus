//
//  GradeHeaderView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 01.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class GradeHeaderView: UITableViewHeaderFooterView {

    private let label = UILabel()

    init(text: String) {
        self.label.text = text
        super.init(reuseIdentifier: nil)
        self.addSubview(self.label)
        self.label.frame = self.bounds
        self.label.textAlignment = .center
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.label.font = .systemFont(ofSize: 20, weight: .semibold)
        self.label.textColor = UIColor.htw.mediumGrey
        self.label.backgroundColor = UIColor.htw.veryLightGrey
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
