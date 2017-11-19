//
//  SettingsService.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class SettingsService: Service {
	func load(parameters: ()) -> Observable<()> {
		return Observable.empty()
	}
}

extension SettingsService: HasSettings {
	var settingsService: SettingsService {
		return self
	}
}
