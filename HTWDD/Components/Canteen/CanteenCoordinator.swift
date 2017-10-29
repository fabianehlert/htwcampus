//
//  CanteenCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class CanteenCoordinator: Coordinator {
    var rootViewController: UIViewController {
        return self.canteenMainVC.inNavigationController()
    }
    var childCoordinators: [Coordinator] = []

    private lazy var canteenMainVC = CanteenMainVC()
}
