//
//  ScheduleCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ScheduleCoordinator: Coordinator {
    var rootViewController: UIViewController {
        return self.scheduleMainViewController.inNavigationController()
    }

    var childCoordinators: [Coordinator] = []

    private lazy var scheduleMainViewController = ScheduleMainVC(context: self.context)

    var auth: ScheduleService.Auth? {
        didSet {
            self.scheduleMainViewController.auth = self.auth
        }
    }

    let context: HasSchedule
    init(context: HasSchedule) {
        self.context = context
    }

    /// Pops the navigation stack back to root.
    func popViewControllers(animated: Bool = true) {
        self.scheduleMainViewController.inNavigationController().popToRootViewController(animated: animated)
    }
    
    /// Pops the navigation stack back to root and scrolls to the current lecture.
    func jumpToToday(animated: Bool = true) {
        self.popViewControllers(animated: animated)
        self.scheduleMainViewController.jumpToToday(animated: animated)
    }
}
