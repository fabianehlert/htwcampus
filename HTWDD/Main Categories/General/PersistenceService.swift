//
//  PersistenceService.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import KeychainAccess

class PersistenceService: Service {

    struct Response {
        var schedule: ScheduleService.Auth
        var grades: GradeService.Auth
    }
    
    private let keychain = Keychain(accessGroup: <#T##String#>)

    func load(parameters: () = ()) -> Observable<Response> {
        
    }

}
