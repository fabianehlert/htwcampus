//
//  Double.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

private let currencyFormatter: NumberFormatter = {
    let nf = NumberFormatter()
    nf.currencySymbol = "€"
    nf.currencyDecimalSeparator = ","
    nf.currencyGroupingSeparator = "."
    nf.numberStyle = NumberFormatter.Style.currency
    return nf
}()

extension Double: HTWNamespaceCompatible {}

extension HTWNamespace where Base == Double {

    var currencyString: String {
        return currencyFormatter.string(from: NSNumber(value: self.base)) ?? self.base.description
    }

}
