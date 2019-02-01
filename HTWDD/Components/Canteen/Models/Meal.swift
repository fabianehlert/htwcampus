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

    let date: Date
    let type: String?
    let counter: String?
    let information: [String]
//    let additives: [String: String] // These two are supported, but cannot currently be decoded due to a bug. Will be fixed soon^^
//    let allergens: [String: String]
//    let furtherNotes: [String]

    private enum CodingKeys: String, CodingKey {
        case title
        case canteen
        case url = "detailURL"
        case imageURL = "image"
        case studentPrice
        case employeePrice
        case type
        case counter
        case information
        case date = "date"
//        case additives
//        case allergens
//        case furtherNotes
    }
}
