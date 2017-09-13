//
//  LectureHeaderView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 09/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class LectureHeaderView: CollectionReusableView, Identifiable {

    var title: String? {
        get {
            return self.label.text
        }
        set {
            self.label.text = newValue
        }
    }

    private let label = UILabel()
    override func initialSetup() {
        self.backgroundColor = .white
        self.label.frame = self.bounds
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.label.textAlignment = .center
        self.addSubview(self.label)
    }

}
