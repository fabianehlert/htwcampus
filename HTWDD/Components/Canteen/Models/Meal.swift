//
//  Meal.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import OpenMensaKit

struct Meal: Identifiable {

    let id: Int
    let name: String
    let category: String
    let studentsPrice: Double
    let employeesPrice: Double
    let notes: [String]

    init(_ openMensaMeal: OpenMensaKit.Meal) {
        self.id = openMensaMeal.id
        self.name = openMensaMeal.name
        self.category = openMensaMeal.category
        self.studentsPrice = openMensaMeal.price.students ?? 0
        self.employeesPrice = openMensaMeal.price.employees ?? 0
        self.notes = openMensaMeal.notes
    }

}
