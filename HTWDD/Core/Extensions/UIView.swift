//
//  UIView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 01.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

extension UIView {

    var width: CGFloat {
        get { return self.bounds.size.width }
        set { self.bounds.size.width = newValue }
    }

    var height: CGFloat {
        get { return self.bounds.size.height }
        set { self.bounds.size.height = newValue }
    }

    var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }

    var bottom: CGFloat {
        get { return self.top + self.height }
        set { self.top = newValue - self.height }
    }

    var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }

    var right: CGFloat {
        get { return self.left + self.width }
        set { self.left = newValue - self.width }
    }

}

extension HTWNamespace where Base: UIView {
	var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.base.safeAreaInsets
        }
        return .zero
	}
    var safeAreaLayoutGuide: LayoutGuide {
        if #available(iOS 11.0, *) {
            return self.base.safeAreaLayoutGuide
        }
        return self.base
    }
}
