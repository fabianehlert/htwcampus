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

    private lazy var scheduleMainViewController = ScheduleMainVC()

    var auth: ScheduleDataSource.Auth? {
        didSet {
            self.scheduleMainViewController.auth = self.auth
        }
    }

    init() {}

}
