//
//  NavigationViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .allButUpsideDown
    }

}
