//
//  Colors.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 19.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit.UIColor

extension UIColor {

    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue: CGFloat(hex & 0x0000FF)        / 255.0,
            alpha: alpha
        )
    }

}

extension HTWNamespace where Base: UIColor {

    static var blue: UIColor {
        return UIColor(hex: 0x004d98)
    }

    static var orange: UIColor {
        return UIColor(hex: 0xF1A13D)
    }

    static var textBody: UIColor {
        return UIColor(hex: 0x7F7F7F)
    }

    static var textHeadline: UIColor {
        return UIColor(hex: 0x000000)
    }

    static var lightBlue: UIColor {
        return UIColor(hex: 0x5060F5)
    }

    static var martianRed: UIColor {
        return UIColor(hex: 0xE35D50)
    }
    
	static var veryLightGrey: UIColor {
		return UIColor(hex: 0xF7F7F7)
	}

	static var lightGrey: UIColor {
		return UIColor(hex: 0xE7E7E7)
	}
	
    static var grey: UIColor {
        return UIColor(hex: 0x7F7F7F)
    }

    static var mediumGrey: UIColor {
        return UIColor(hex: 0x5A5A5A)
    }

    static var darkGrey: UIColor {
        return UIColor(hex: 0x474747)
    }
    
    static var white: UIColor {
        return UIColor(hex: 0xFFFFFF)
    }
	
	static var scheduleColors: [UIColor] {
		let colors = [
			UIColor(hex: 0xC21717),
			UIColor(hex: 0xf39c12),
			UIColor(hex: 0x8e44ad),
			UIColor(hex: 0x27ae60),
			UIColor(hex: 0xe74c3c),
			UIColor(hex: 0x3498db),
			UIColor(hex: 0xF0C987),
			UIColor(hex: 0x9097C0),
			UIColor(hex: 0xf1c40f),
			UIColor(hex: 0x2c3e50),
			UIColor(hex: 0xc0392b),
			UIColor(hex: 0xE8C1C5)
		]
		return colors
	}
}
