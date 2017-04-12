//
//  AppDelegate.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 07/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit

class AppContext: CoordinatorBridge {

}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    private let bridge = AppContext()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if NSClassFromString("XCTestCase") != nil {
            return true
        }

        let window = UIWindow()
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.initialize(bridge: self.bridge)
        appCoordinator.start(bridge: self.bridge)

        self.appCoordinator = appCoordinator
        self.window = window

        return true
    }

}
