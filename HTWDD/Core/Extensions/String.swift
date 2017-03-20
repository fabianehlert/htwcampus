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

}
