//
//  ViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 15/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func inNavigationController() -> NavigationController {
        if let n = self.navigationController as? NavigationController {
            return n
        }
        return NavigationController(rootViewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}
