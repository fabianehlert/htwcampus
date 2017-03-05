//
//  EventDate_TestCase.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import XCTest
@testable import HTWDD

class EventDate_TestCase: XCTestCase {

    func test_init() {
        let raw = "2000-02-20"
        guard let date = EventDate(raw: raw) else {
            XCTFail("Expected date to be non nil.")
            return
        }

        XCTAssertEqual(date.year, 2000)
        XCTAssertEqual(date.month, 2)
        XCTAssertEqual(date.day, 20)

        XCTAssertNil(EventDate(raw: ""))
        XCTAssertNil(EventDate(raw: "2000-13-10"))
        XCTAssertNil(EventDate(raw: "2000-12-32"))
        XCTAssertNil(EventDate(raw: "2000-0-12"))
        XCTAssertNil(EventDate(raw: "2000-3-0"))
        XCTAssertNil(EventDate(raw: "a-12-3"))
        XCTAssertNil(EventDate(raw: "2000-a-3"))
        XCTAssertNil(EventDate(raw: "2000-3-a"))
    }

}
