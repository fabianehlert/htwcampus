//
//  Lecture_TestCase.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import XCTest
@testable import HTWDD

class Lecture_TestCase: XCTestCase {

    func test_day_add() {

        let d1 = Day.monday
        XCTAssertEqual(d1.dayByAdding(days: 3), Day.thursday)
        XCTAssertEqual(d1.dayByAdding(days: 13), Day.sunday)
        XCTAssertEqual(d1.dayByAdding(days: 30), Day.wednesday)
        XCTAssertEqual(d1.dayByAdding(days: 21), Day.monday)

        XCTAssertEqual(d1.dayByAdding(days: -1), Day.sunday)
        XCTAssertEqual(d1.dayByAdding(days: -7), Day.monday)
        XCTAssertEqual(d1.dayByAdding(days: -13), Day.tuesday)
    }

}
