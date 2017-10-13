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

    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if NSClassFromString("XCTestCase") != nil {
            return true
        }

        let window = UIWindow()

		self.appCoordinator = AppCoordinator(window: window)
		self.window = window

        return true
    }

}
