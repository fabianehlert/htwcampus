//
//  SettingsCoordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		return self.settingsController.inNavigationController()
	}
	
	var childCoordinators = [Coordinator]()
	
	private lazy var settingsController = SettingsMainVC()
	
	let context: HasSettings
	init(context: HasSettings) {
		self.context = context
	}
}
