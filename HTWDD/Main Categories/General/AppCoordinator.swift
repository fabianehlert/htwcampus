//
//  AppCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 26/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject, Coordinator {

    enum Category: Int {
        case schedule, grade
    }

    var rootViewController: UIViewController {
        return self.tabBarController
    }

    private var window: UIWindow?
    let tabBarController: TabBarController
    fileprivate let children: [(category: Category, coordinator: Coordinator)]

    init(window: UIWindow) {
        self.window = window
        self.tabBarController = TabBarController()

        self.children = [
            (.schedule, ScheduleCoordinator(tabbarController: self.tabBarController)),
            (.grade, GradeCoordinator(tabbarController: self.tabBarController))
        ]

        super.init()

        self.tabBarController.delegate = self
        window.rootViewController = self.tabBarController

        let controllers = self.children.flatMap {
            return $0.coordinator.rootViewController
        }

        self.tabBarController.setViewControllers(controllers, animated: false)
    }

    func initialize(bridge: CoordinatorBridge) {
        SettingsManager.shared.loadInitial()

        self.children.forEach {
            $0.coordinator.initialiaze(bridge: bridge)
        }
    }

    fileprivate var bridge: CoordinatorBridge?
    func start(bridge: CoordinatorBridge) {
        self.bridge = bridge
        self.children.first?.1.start(bridge: bridge)
        self.window?.makeKeyAndVisible()
    }

}

extension AppCoordinator: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let bridge = self.bridge else {
            return
        }

        self.children.first(where: { _, coordinator in
            coordinator.rootViewController === viewController
        })?.coordinator.start(bridge: bridge)
    }

}
