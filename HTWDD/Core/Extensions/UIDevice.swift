//
//  UIDevice.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 15.12.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
}
