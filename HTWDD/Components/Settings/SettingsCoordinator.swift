//
//  SettingsCoordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

protocol SettingsCoordinatorDelegate: class {
    func deleteAllData()
}

class SettingsCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		return self.settingsController.inNavigationController()
	}
	
	var childCoordinators = [Coordinator]()
	
    private lazy var settingsController: SettingsMainVC = {
        let vc = SettingsMainVC()
        vc.delegate = self
        return vc
    }()
	
    weak var delegate: SettingsCoordinatorDelegate?
    
	let context: HasSettings
    init(context: HasSettings, delegate: SettingsCoordinatorDelegate) {
		self.context = context
        self.delegate = delegate
	}
}

extension SettingsCoordinator: SettingsMainVCDelegate {
    func deleteAllData() {
        self.delegate?.deleteAllData()
    }
}
