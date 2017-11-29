//
//  SettingsCoordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import SafariServices

protocol SettingsCoordinatorDelegate: class {
    func deleteAllData()
    func triggerScheduleOnboarding(completion: @escaping (ScheduleService.Auth) -> Void)
    func triggerGradeOnboarding(completion: @escaping (GradeService.Auth) -> Void)
}

class SettingsCoordinator: Coordinator {
	
    var scheduleAuth: ScheduleService.Auth? {
        didSet {
            self.settingsController.scheduleAuth = self.scheduleAuth
        }
    }
    
    var gradeAuth: GradeService.Auth? {
        didSet {
            self.settingsController.gradesAuth = self.gradeAuth
        }
    }
    
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
    
    func triggerScheduleOnboarding(completion: @escaping (ScheduleService.Auth) -> Void) {
        self.delegate?.triggerScheduleOnboarding(completion: completion)
    }
    
    func triggerGradeOnboarding(completion: @escaping (GradeService.Auth) -> Void) {
        self.delegate?.triggerGradeOnboarding(completion: completion)
    }
	
	func showLicense(name: String) {
		let webVC = WebViewController(fileName: name)
		if let root = self.rootViewController as? NavigationController {
			root.pushViewController(webVC, animated: true)
		}
	}
	
	func showGitHub() {
		let safariVC = SFSafariViewController(url: URL(string: "https://github.com/HTWDD/htwcampus")!)
		if #available(iOS 10.0, *) {
			safariVC.preferredControlTintColor = UIColor.htw.blue
		}
		self.rootViewController.present(safariVC, animated: true, completion: nil)
	}
}
