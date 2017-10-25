//
//  LectureTimeView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 09/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class LectureTimeView: CollectionReusableView, Identifiable {

	private let label = UILabel()

    var timeString: String? {
        get {
            return self.label.text
        }
        set {
			// TODO: properly generate array consisting of hours of the day.
			self.label.text = newValue?.appending(":00")
        }
    }

	// MARK: - Init

    override func initialSetup() {
		self.backgroundColor = UIColor.htw.veryLightGrey

        self.label.frame = self.bounds
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.label.font = .systemFont(ofSize: 14, weight: .semibold)
		self.label.textColor = UIColor.htw.textBody
        self.label.textAlignment = .center
        self.addSubview(self.label)
    }

}
