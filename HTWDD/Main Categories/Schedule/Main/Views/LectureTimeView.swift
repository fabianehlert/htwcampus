//
//  LectureTimeView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 09/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class LectureTimeView: CollectionReusableView, Identifiable {

    var timeString: String? {
        get {
            return self.label.text
        }
        set {
            self.label.text = newValue
        }
    }

    private let label = UILabel()
    override func initialSetup() {
        self.label.frame = self.bounds
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.label.textAlignment = .center
        self.addSubview(self.label)
    }

}
