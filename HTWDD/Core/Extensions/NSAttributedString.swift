//
//  NSAttributedString.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 15.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

extension NSAttributedString {
    static func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let temp = NSMutableAttributedString(attributedString: lhs)
        temp.append(rhs)
        return NSAttributedString(attributedString: temp)
    }
    
    static func +(lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
}
