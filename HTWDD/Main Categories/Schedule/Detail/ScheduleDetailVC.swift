//
//  ScheduleDetailVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ScheduleDetailVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: self.view.bounds)
        button.setTitle("PRESS ME", for: .normal)
        button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(button)
        self.view.backgroundColor = .red
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
            let before = self.view.frame
            self.view.frame = source
            UIView.animate(withDuration: duration, animations: {
                self.view.frame = before
                self.view.alpha = 1
            }, completion: completion)

        case .dismiss:
            UIView.animate(withDuration: duration, animations: {
                self.view.frame = source
                self.view.alpha = 0
            }, completion: completion)
        }

    }

}
