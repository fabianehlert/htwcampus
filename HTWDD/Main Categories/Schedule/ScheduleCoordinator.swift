//
//  ScheduleCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 25/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ScheduleCoordinator: Coordinator {

    var rootViewController: UIViewController {
        return self.mainViewController
    }

    private let tabbarController: TabBarController
    private let mainViewController = ScheduleMainVC().inNavigationController()
    init(tabbarController: TabBarController) {
        self.tabbarController = tabbarController
    }

    func start(bridge: CoordinatorBridge) {
        self.tabbarController.selectedViewController = self.rootViewController
    }

}
