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

    let canteen: Canteen.Id
    let date: Date

    init(canteen: Canteen.Id, date: Date, openMensaMeal: OpenMensaKit.Meal) {
        self.id = openMensaMeal.id
        self.name = openMensaMeal.name
        self.category = openMensaMeal.category
        self.studentsPrice = openMensaMeal.price.students ?? 0
        self.employeesPrice = openMensaMeal.price.employees ?? 0
        self.notes = openMensaMeal.notes

        self.canteen = canteen
        self.date = date
    }

    var imageUrl: URL? {
        guard let imageId = self.canteen.imageId else {
            return nil
        }
        let year = self.date.components.year ?? 0
        let month = self.date.components.month ?? 0

        let urlString = "https://bilderspeiseplan.studentenwerk-dresden.de/m\(imageId)/\(year)\(month)/thumbs/\(self.id).jpg"

        return URL(string: urlString)
    }

}
