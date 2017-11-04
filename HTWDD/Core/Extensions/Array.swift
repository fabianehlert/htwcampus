//
//  Array.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 26/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

extension Array {

    subscript(safe index: Index) -> Element? {
        guard count > index else {
            return nil
        }
        return self[index]
    }

	func pickOne() -> Iterator.Element {
		let i = Int(arc4random() % UInt32(self.count))
		return self[i]
	}

}
