//
//  Authenticator_TestCase.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import XCTest
@testable import HTWDD

class Authenticator_TestCase: XCTestCase {

    func test_base() {

        var req = URLRequest(url: URL(string: "https://example.com")!)
        let base = Base(username: "user", password: "password")
        XCTAssertNil(req.allHTTPHeaderFields)
        base.authenticate(request: &req)
        XCTAssertEqual(req.allHTTPHeaderFields ?? [:], ["Authorization": "Basic \("user:password".base64)"])
    }

}
