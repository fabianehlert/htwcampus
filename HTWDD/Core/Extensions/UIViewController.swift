//
//  UIViewContorller.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

private var transitionKey: UInt8 = 0

extension UIViewController {

    var transition: UIViewControllerTransitioningDelegate? {
        get {
            return objc_getAssociatedObject(self, &transitionKey) as? UIViewControllerTransitioningDelegate
        }
        set {
            objc_setAssociatedObject(self, &transitionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.transitioningDelegate = newValue
        }
    }

}
