//
//  SettingsManager_Tests.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import XCTest
@testable import HTWDD

class SettingsManager_Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaults.standard.clear()
    }

    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.clear()
    }

    func test_save_empty() {
        let s = SettingsManager()
        XCTAssertNil(UserDefaults.standard.object(forKey: "HTW_Settings_Key"))
        s.save()
        let saved = UserDefaults.standard.object(forKey: "HTW_Settings_Key")
        XCTAssertNotNil(UserDefaults.standard.object(forKey: "HTW_Settings_Key"))

        guard let data = saved as? Data else {
            XCTFail("saved data is of wrong type")
            return
        }

        guard let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            XCTFail("saved data is not a dictionary")
            return
        }

        XCTAssertEqual(dictionary.count, 0)
    }

    func test_save_notEmpty() {
        let testNumber = "s12345"
        let s = SettingsManager()
        XCTAssertNil(s.sNumber.value)
        s.sNumber.value = testNumber
        XCTAssertNotNil(s.sNumber.value, "value should be saved")

        s.save()
        XCTAssertNotNil(s.sNumber.value, "value should not be changed")
        XCTAssertEqual(s.sNumber.value, testNumber)

        let saved = UserDefaults.standard.object(forKey: "HTW_Settings_Key")
        guard let data = saved as? Data else {
            XCTFail("saved data is of wrong type")
            return
        }

        guard let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            XCTFail("saved data is not a dictionary")
            return
        }

        XCTAssertEqual(dictionary.count, 1)
        XCTAssertEqual(dictionary["sNumber"] as? String, testNumber)
    }

    func test_loadInitial() {
        let testNumber = "s12345"

        let dictionary = [
            "sNumber": testNumber
        ]

        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        UserDefaults.standard.set(data, forKey: "HTW_Settings_Key")

        let s = SettingsManager()
        XCTAssertNil(s.sNumber.value)

        s.loadInitial()
        XCTAssertNotNil(s.sNumber.value)
        XCTAssertEqual(s.sNumber.value, testNumber)
    }

}
