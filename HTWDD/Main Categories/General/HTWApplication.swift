//
//  HTWApplication.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 26/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class HTWApplication: NSObject {

    enum Category: Int {
        case schedule, grade
    }

    var rootViewController: UIViewController {
        return self.tabBarController
    }

    private var window: UIWindow?
    private let bridge: AppContext
    let tabBarController: TabBarController
    fileprivate let children: [(category: Category, controller: UIViewController)]

    init(window: UIWindow, bridge: AppContext) {
        self.window = window
        self.bridge = bridge
        self.tabBarController = TabBarController()

        self.children = [
            (.schedule, ScheduleMainVC().inNavigationController()),
            (.grade, GradeMainVC().inNavigationController())
        ]

        super.init()

        window.rootViewController = self.tabBarController

        let controllers = self.children.flatMap { pair in
            return pair.controller
        }

        self.tabBarController.setViewControllers(controllers, animated: false)
    }

    func start() {
        self.window?.makeKeyAndVisible()
    }

}
