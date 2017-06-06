//
//  Authenticator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

public protocol Authenticator {
    func authenticate(request: inout URLRequest)
}

class Base: Authenticator {

    private let base64String: String

    init(username: String, password: String) {
        self.base64String = "\(username):\(password)".base64
    }

    func authenticate(request: inout URLRequest) {
        request.addValue("Basic \(self.base64String)", forHTTPHeaderField: "Authorization")
    }

}
