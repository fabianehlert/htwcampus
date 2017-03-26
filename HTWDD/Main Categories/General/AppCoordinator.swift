//
//  AppCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 26/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {

    enum Category: Int {
        case schedule
    }

    var rootViewController: UIViewController {
        return self.tabBarController
    }

    private var window: UIWindow?
    let tabBarController: TabBarController
    private let childs: [(category: Category, coordinator: Coordinator)]

    init(window: UIWindow) {
        self.window = window
        self.tabBarController = TabBarController()
        window.rootViewController = self.tabBarController

        self.childs = [
            (.schedule, ScheduleCoordinator(tabbarController: self.tabBarController))
        ]

        let controllers = self.childs.flatMap {
            return $0.coordinator.rootViewController
        }

        self.tabBarController.setViewControllers(controllers, animated: false)
    }

    func initialiaze(bridge: CoordinatorBridge) {
        SettingsManager.shared.loadInitial()

        self.childs.forEach {
            $0.coordinator.initialiaze(bridge: bridge)
        }
    }

    func start(bridge: CoordinatorBridge) {
        self.childs.first?.1.start(bridge: bridge)
        self.window?.makeKeyAndVisible()
    }

}
