//
//  Either.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 25.02.18.
//  Copyright © 2018 HTW Dresden. All rights reserved.
//

import Foundation

enum Either<A, B> {
    case left(A), right(B)
}
