//
//  String_TestCase.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import XCTest
@testable import HTWDD

class String_TestCase: XCTestCase {

    func test_base64Encode() {
        let input = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut l"
        let expectedOutput = "TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNldGV0dXIgc2FkaXBzY2luZyBlbGl0ciwgc2VkIGRpYW0gbm9udW15IGVpcm1vZCB0ZW1wb3IgaW52aWR1bnQgdXQgbA=="

        XCTAssertEqual(expectedOutput, input.base64)
    }

}
