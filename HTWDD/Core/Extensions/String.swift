//
//  String.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

extension String {

    var base64: String {
        return Data(self.utf8).base64EncodedString()
    }

	func rangeOfSubString(_ string: String) -> NSRange? {
		let range = NSString(string: self).range(of: string)
		return range.location != NSNotFound ? range : nil
	}

}

enum Constants {
	static let groupID = "group.htw-dresden.ios"
}
