//
//  Coordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 25/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

protocol CoordinatorBridge {
    // contains references for settings and user related stuff
}

protocol Coordinator {

    var rootViewController: UIViewController { get }
    func start(bridge: CoordinatorBridge)
    func initialiaze(bridge: CoordinatorBridge)
}

extension Coordinator {
    func initialiaze(bridge: CoordinatorBridge) {
        // default implementation is empty
    }
}
