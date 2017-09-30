//
//  ScheduleDetailVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import Cartography

class ScheduleDetailVC: ViewController {

    private let viewModel: ScheduleDetailContentViewModel

    private let label = UILabel()

    init(lecture: Lecture) {
        self.viewModel = ScheduleDetailContentViewModel(lecture: lecture)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.label.text = self.viewModel.tag
        self.view.addSubview(label)

        constrain(self.view, self.label) { container, label in
            label.edges == container.edgesWithinMargins
        }
    }

    @objc
    private func tapRecognized(_ sender: UIGestureRecognizer) {
        self.dismiss(animated: true)
    }

}
