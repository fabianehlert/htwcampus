//
//  AppDelegate.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 07/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if NSClassFromString("XCTestCase") != nil {
            return true
        }

        baseInitialization()

        self.window = UIWindow()
        self.window?.rootViewController = ScheduleMainVC().inNavigationController()
        self.window?.makeKeyAndVisible()
        return true
    }

    private func baseInitialization() {
        SettingsManager.shared.loadInitial()
    }

}
