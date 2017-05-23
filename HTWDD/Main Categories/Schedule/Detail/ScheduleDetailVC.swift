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

    private let content: ScheduleDetailContentView

    private let lecture: Lecture

    init(lecture: Lecture) {
        self.lecture = lecture
        self.content = ScheduleDetailContentView(lecture: lecture)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.buttonPressed(_:)))
        self.view.addGestureRecognizer(gesture)
        self.view.backgroundColor = UIColor.red.withAlphaComponent(0.3)

        self.content.backgroundColor = .blue
        self.content.layer.cornerRadius = 10
        self.view.addSubview(self.content)

        self.addConstraints()
    }

    var correctGroup = ConstraintGroup()

    @discardableResult
    func constraincontent(to frame: CGRect) -> ConstraintGroup {
        return constrain(self.view, self.content, block: { view, content in
            content.leading == view.leading + frame.origin.x
            content.width == frame.size.width
            content.top == view.top + frame.origin.y
            content.height == frame.size.height
        })
    }

    func addConstraints() {
        self.correctGroup = constrain(self.view, self.content, block: { view, content in
            content.edges == inset(view.edges, 50) ~ 700
            content.width <= 350 ~ LayoutPriority(1000)
            content.height <= 200 ~ LayoutPriority(1000)
            content.center == view.center ~ 1000
        })
    }

    func buttonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ScheduleDetailVC: AnimatedViewControllerTransitionAnimator {

    func animate(source: CGRect, duration: TimeInterval, direction: Direction, completion: @escaping (Bool) -> Void) {

        switch direction {
        case .present:
            self.view.alpha = 0
            let small = self.constraincontent(to: source)
            self.correctGroup.active = false
            self.view.layoutIfNeeded()
            small.active = false
            self.correctGroup.active = true

            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseInOut], animations: {
                self.view.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: completion)

        case .dismiss:
            self.correctGroup.active = false
            self.constraincontent(to: source)
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
                self.view.alpha = 0
            }, completion: completion)
        }

    }

}
