//
//  ScheduleDetailContentView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import Cartography

class ScheduleDetailContentView: View {

    let lecture: Lecture

    private let label = UILabel()

    init(lecture: Lecture) {
        self.lecture = lecture
        super.init(frame: .zero)
        self.label.text = self.lecture.tag

        self.addSubview(label)
        constrain(self, self.label) { container, label in
            label.edges == container.edgesWithinMargins
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
