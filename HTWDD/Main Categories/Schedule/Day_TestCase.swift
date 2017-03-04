//
//  Day_TestCase.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import XCTest
@testable import HTWDD

class Day_TestCase: XCTestCase {

    func test_fromComponents() {

        XCTAssertNotNil(Date.from(day: 1, month: 4, year: 2000))
        XCTAssertNotNil(Date.from(day: 1, month: 4, year: 2090))
        XCTAssertNotNil(Date.from(day: 30, month: 4, year: 2090))

        XCTAssertEqual(Date.from(day: 31, month: 4, year: 2017), Date.from(day: 1, month: 5, year: 2017))
        XCTAssertEqual(Date.from(day: -1, month: 4, year: 2017), Date.from(day: 30, month: 3, year: 2017))
        XCTAssertEqual(Date.from(day: 50, month: 4, year: 2017), Date.from(day: 20, month: 5, year: 2017))
        XCTAssertEqual(Date.from(day: 1, month: 13, year: 2017), Date.from(day: 01, month: 01, year: 2018))

    }

    func test_weekday() {
        var date = Date.from(day: 4, month: 3, year: 2017)
        XCTAssertEqual(date?.weekday, Day.saturday)

        date = Date.from(day: 24, month: 12, year: 2017)
        XCTAssertEqual(date?.weekday, Day.sunday)

        date = Date.from(day: 20, month: 03, year: 2017)
        XCTAssertEqual(date?.weekday, Day.monday)

        date = Date.from(day: 30, month: 03, year: 2017)
        XCTAssertEqual(date?.weekday, Day.thursday)
    }

}
