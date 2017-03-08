//
//  Semester_Tests.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import XCTest
@testable import HTWDD

class Semester_Tests: XCTestCase {

    func test_init() throws {
        _ = try Semester.value(from: "abc")
        _ = try Semester.value(from: "20039")
        _ = try Semester.value(from: "abcdf")
        _ = try Semester.value(from: "this is some arbitrary string")

        var s = try Semester.value(from: "20122")

        XCTAssertEqual(s.year, 2012)
        XCTAssertTrue(Semester.winter(year: 2012) ~= s)

        s = try Semester.value(from: "30001")
        XCTAssertEqual(s.year, 3000)
        XCTAssertTrue(Semester.summer(year: 3000) ~= s)
    }

    func test_description() {
        let s1 = Semester.summer(year: 2016)
        XCTAssertEqual(s1.description, "SS_2016")

        let s2 = Semester.winter(year: 3021)
        XCTAssertEqual(s2.description, "WS_3021")
    }

    func test_hashValue() {
        let s1 = Semester.summer(year: 2016)
        XCTAssertEqual(s1.hashValue, "SS_2016".hashValue)

        let s2 = Semester.winter(year: 3021)
        XCTAssertEqual(s2.hashValue, "WS_3021".hashValue)
    }

    func test_comparable() {
        let s1 = Semester.winter(year: 2000)
        let s2 = Semester.winter(year: 2001)
        XCTAssertTrue(s1 < s2)

        let s3 = Semester.summer(year: 2000)
        let s4 = Semester.summer(year: 2001)
        XCTAssertTrue(s3 < s4)

        let s5 = Semester.summer(year: 2000)
        let s6 = Semester.winter(year: 2000)
        XCTAssertTrue(s5 < s6)

        let s7 = Semester.winter(year: 2000)
        let s8 = Semester.summer(year: 2000)
        XCTAssertTrue(s7 > s8)
    }

    func test_equality() {
        let s1 = Semester.summer(year: 2012)
        let s2 = Semester.summer(year: 2012)
        XCTAssertEqual(s1, s2)

        let s3 = Semester.summer(year: 2012)
        let s4 = Semester.winter(year: 2012)
        XCTAssertNotEqual(s3, s4)

        let s5 = Semester.summer(year: 2012)
        let s6 = Semester.summer(year: 2013)
        XCTAssertNotEqual(s5, s6)
    }

}
