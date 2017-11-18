//
//  Grade_Tests.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import XCTest
@testable import HTWDD

class Grade_Tests: XCTestCase {

    func test_equality() {
        var g1 = Grade(nr: 0, state: .passed, credits: 1.0, text: "", semester: Semester.summer(year: 1), numberOfTry: 0, date: Date(), mark: 0, note: nil, form: "")
        var g2 = Grade(nr: 1, state: .passed, credits: 1.0, text: "", semester: Semester.summer(year: 1), numberOfTry: 0, date: Date(), mark: 0, note: nil, form: "")
        XCTAssertNotEqual(g1, g2)

        g1 = Grade(nr: 0, state: .passed, credits: 1.0, text: "", semester: Semester.summer(year: 1), numberOfTry: 0, date: Date(), mark: 0, note: nil, form: "")
        g2 = Grade(nr: 0, state: .passed, credits: 2.0, text: "", semester: Semester.summer(year: 1), numberOfTry: 0, date: Date(), mark: 0, note: nil, form: "")
        XCTAssertNotEqual(g1, g2)

        g1 = Grade(nr: 0, state: .passed, credits: 1.0, text: "", semester: Semester.summer(year: 1), numberOfTry: 0, date: Date(), mark: 0, note: nil, form: "")
        g2 = Grade(nr: 0, state: .passed, credits: 1.0, text: "", semester: Semester.summer(year: 2), numberOfTry: 0, date: Date(), mark: 0, note: nil, form: "")
        XCTAssertNotEqual(g1, g2)

        g1 = Grade(nr: 0, state: .passed, credits: 1.0, text: "", semester: Semester.summer(year: 1), numberOfTry: 0, date: Date(), mark: 0, note: nil, form: "")
        g2 = Grade(nr: 0, state: .passed, credits: 1.0, text: "", semester: Semester.summer(year: 1), numberOfTry: 0, date: Date(), mark: 1, note: nil, form: "")
        XCTAssertNotEqual(g1, g2)

        g1 = Grade(nr: 0, state: .passed, credits: 1.0, text: "text", semester: Semester.summer(year: 1), numberOfTry: 3, date: Date(timeIntervalSince1970: 0), mark: 0, note: "a note", form: "")
        g2 = Grade(nr: 0, state: .passed, credits: 1.0, text: "", semester: Semester.summer(year: 1), numberOfTry: 0, date: Date(), mark: 0, note: nil, form: "")
        XCTAssertEqual(g1, g2)

    }

}
