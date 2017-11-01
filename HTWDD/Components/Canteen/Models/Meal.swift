//
//  Meal.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

struct Meal: Identifiable, Decodable {
    let title: String
    let canteen: String

    let url: URL
    let imageURL: URL?

    let studentPrice: Double?
    let employeePrice: Double?

    let type: String
    let counter: String
    let information: [String]
    let additives: [String: String]
    let allergens: [String: String]
    let furtherNotes: [String]

    private enum CodingKeys: String, CodingKey {
        case title
        case canteen = "mensa"
        case url = "link"
        case imageURL = "image"
        case studentPrice
        case employeePrice
        case type = "mealType"
        case counter = "mealCounter"
        case information = "informations"
        case additives
        case allergens
        case furtherNotes
    }
}
