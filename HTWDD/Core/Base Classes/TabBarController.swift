//
//  TabBarCotroller.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 26/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

protocol TabbarChildViewController: class {
    func tabbarControllerDidSelectAlreadyActiveChild()
}

class TabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }

    private func initialSetup() {
        self.delegate = self
    }

}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard viewController === self.selectedViewController else {
            return true
        }

        if let child = viewController as? TabbarChildViewController {
            child.tabbarControllerDidSelectAlreadyActiveChild()
        } else if let nav = viewController as? UINavigationController, let child = nav.viewControllers.last as? TabbarChildViewController {
            child.tabbarControllerDidSelectAlreadyActiveChild()
        }

        return true
    }
}
