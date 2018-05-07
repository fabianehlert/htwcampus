//
//  URL.swift
//  HTWDD
//
//  Created by martin on 02.05.18.
//  Copyright © 2018 HTW Dresden. All rights reserved.
//

import Foundation

enum Component: Int {
    
    case scheduleTab
    case examsTab
    case gradesTab
    case canteenTab
    case settingsTab
    
    static let components: [Component: String] = [
        .scheduleTab: "schedule",
        .examsTab: "exams",
        .gradesTab: "grades",
        .canteenTab: "canteen",
        .settingsTab: "settings",
        ]
    
    var string: String {
        return Component.components[self]!
    }
}

extension HTWNamespace where Base == URL {
    
    static var prefix: String {
        return "htwdd://"
    }
    
    static func urlFromComponent(component: Component) -> URL? {
        return URL(string: prefix + component.string)
    }
    
    static func caseForValue(componentValue: String) -> Component {
        
        if let index = Component.components.values.index(of: componentValue) {
            return Component.components.keys[index]
        }
        return Component.scheduleTab
    }
}
