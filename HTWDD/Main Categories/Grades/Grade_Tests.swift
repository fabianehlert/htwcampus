//
//  Grade_Tests.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import XCTest
@testable import HTWDD

class Semester_Tests: XCTestCase {

    func test_init() {
        XCTAssertNil(Grade.Semester(rawValue: "abc"))
        XCTAssertNil(Grade.Semester(rawValue: "20039"))
        XCTAssertNil(Grade.Semester(rawValue: "abcdf"))
        XCTAssertNil(Grade.Semester(rawValue: "this is some arbitrary string"))

        guard var s = Grade.Semester(rawValue: "20122") else {
            XCTFail("20122 was not parsed as a valid semester string")
            return
        }

        XCTAssertEqual(s.year, 2012)
        XCTAssertTrue(Grade.Semester.winter(year: 2012) ~= s)

        s = Grade.Semester(rawValue: "30001")!
        XCTAssertEqual(s.year, 3000)
        XCTAssertTrue(Grade.Semester.summer(year: 3000) ~= s)
    }

    func test_description() {
        let s1 = Grade.Semester.summer(year: 2016)
        XCTAssertEqual(s1.description, "SS_2016")

        let s2 = Grade.Semester.winter(year: 3021)
        XCTAssertEqual(s2.description, "WS_3021")
    }

    func test_hashValue() {
        let s1 = Grade.Semester.summer(year: 2016)
        XCTAssertEqual(s1.hashValue, "SS_2016".hashValue)

        let s2 = Grade.Semester.winter(year: 3021)
        XCTAssertEqual(s2.hashValue, "WS_3021".hashValue)
    }

    func test_comparable() {
        let s1 = Grade.Semester.winter(year: 2000)
        let s2 = Grade.Semester.winter(year: 2001)
        XCTAssertTrue(s1 < s2)

        let s3 = Grade.Semester.summer(year: 2000)
        let s4 = Grade.Semester.summer(year: 2001)
        XCTAssertTrue(s3 < s4)

        let s5 = Grade.Semester.summer(year: 2000)
        let s6 = Grade.Semester.winter(year: 2000)
        XCTAssertTrue(s5 < s6)

        let s7 = Grade.Semester.winter(year: 2000)
        let s8 = Grade.Semester.summer(year: 2000)
        XCTAssertTrue(s7 > s8)
    }

    func test_equality() {
        let s1 = Grade.Semester.summer(year: 2012)
        let s2 = Grade.Semester.summer(year: 2012)
        XCTAssertEqual(s1, s2)

        let s3 = Grade.Semester.summer(year: 2012)
        let s4 = Grade.Semester.winter(year: 2012)
        XCTAssertNotEqual(s3, s4)

        let s5 = Grade.Semester.summer(year: 2012)
        let s6 = Grade.Semester.summer(year: 2013)
        XCTAssertNotEqual(s5, s6)
    }

}

class Grade_Tests: XCTestCase {

}
