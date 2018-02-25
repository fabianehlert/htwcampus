//
//  GradeServiceTests.swift
//  HTWDDTests
//
//  Created by Benjamin Herzog on 25.02.18.
//  Copyright © 2018 HTW Dresden. All rights reserved.
//

import XCTest
@testable import HTWDD

class GradeServiceTests: XCTestCase {
    
    func test_calculateAverage() {
        
        func testPairs(_ pairs: [(credits: Double, mark: Double?)], expected average: Double) {
            let grades = pairs.map { grade in
                return Grade(nr: 0, state: .passed, credits: grade.credits, text: "", semester: .summer(year: 0), numberOfTry: 0, date: nil, mark: grade.mark, note: nil, form: nil)
            }
            
            let information = GradeService.Information(semester: .summer(year: 0), grades: grades)
            
            XCTAssertEqual(GradeService.calculateAverage(from: [information]), average, accuracy: 0.01)
        }
        
        testPairs([(5.0, 1.0), (2.0, 3.0)], expected: 1.57)
        testPairs([(0.0, 1.0), (5.0, 3.0)], expected: 3.0)
        
    }
    
}
