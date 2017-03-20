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

    let button = UIButton()
    let container = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.button.setTitle("PRESS ME", for: .normal)
        self.button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
        self.container.addSubview(button)
        self.view.backgroundColor = UIColor.red.withAlphaComponent(0.3)

        self.container.backgroundColor = .blue
        self.container.layer.cornerRadius = 10
        self.view.addSubview(self.container)

        self.addConstraints()
    }

    var correctGroup = ConstraintGroup()

    @discardableResult
    func constrainContainer(to frame: CGRect) -> ConstraintGroup {
        return constrain(self.view, self.container, block: { view, container in
            container.leading == view.leading + frame.origin.x
            container.width == frame.size.width
            container.top == view.top + frame.origin.y
            container.height == frame.size.height
        })
    }

    func addConstraints() {
        constrain(self.container, self.button) { view, button in
            button.height == 40
            button.bottom == view.bottom
            button.leading == view.leading
            button.trailing == view.trailing
        }

        self.correctGroup = constrain(self.view, self.container, block: { view, container in
            container.edges == inset(view.edges, 50) ~ 700
            container.width <= 350 ~ LayoutPriority(1000)
            container.height <= 200 ~ LayoutPriority(1000)
            container.center == view.center ~ 1000
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
            let small = self.constrainContainer(to: source)
            self.correctGroup.active = false
            self.view.layoutIfNeeded()
            small.active = false
            self.correctGroup.active = true

            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [.curveEaseInOut], animations: {
                self.view.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: completion)

        case .dismiss:
            self.correctGroup.active = false
            self.constrainContainer(to: source)
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
                self.view.alpha = 0
            }, completion: completion)
        }

    }

}
