//
//  ExamsService.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class ExamsService: Service {
    func load(parameters: ()) -> Observable<()> {
        return Observable.empty()
    }
}

extension ExamsService: HasExams {
    var examService: ExamsService {
        return self
    }
}
