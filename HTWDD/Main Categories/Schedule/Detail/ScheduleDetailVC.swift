//
//  ScheduleDetailVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ScheduleDetailVC: ViewController {

    @IBAction func buttonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ScheduleDetailVC: AnimatedViewControllerTransitionAnimator {

    func animate(source: CGRect, duration: TimeInterval, direction: Direction, completion: @escaping (Bool) -> Void) {

        switch direction {

        case .present:
            self.view.alpha = 0
            UIView.animate(withDuration: duration, animations: {
                self.view.alpha = 1
            }, completion: completion)

        case .dismiss:
            self.view.alpha = 1
            UIView.animate(withDuration: duration, animations: {
                self.view.alpha = 0
            }, completion: completion)
        }

    }

}
