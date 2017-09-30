//
//  Log.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

final class Log {

    static func error(_ error: @autoclosure () -> Error) {
        self.error(String(describing: error()))
    }

    static func error(_ error: @autoclosure () -> String) {
        print("‼️", error())
    }

    static func info(_ text: @autoclosure () -> String) {
        print("⚠️", text())
    }

    static func typeAsString(_ obj: Any) -> String {
        return String(describing: type(of: obj))
    }

}
