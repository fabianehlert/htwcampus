//
//  OnboardingCoordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardingCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []

	private lazy var navigationController: NavigationController = {
		let navigationController = NavigationController()
		navigationController.navigationBar.isHidden = true
		return navigationController
	}()

	var rootViewController: UIViewController {
		return self.navigationController
	}

	var onFinish: ((ScheduleService.Auth?, GradeService.Auth?) -> Void)?

	// MARK: - Init

	init() {
		self.showWelcomeOnboarding()
	}

	private func showWelcomeOnboarding() {
		let welcome = OnboardWelcomeViewController()
		welcome.onContinue = { [weak self] vc in
			self?.showStudyGroupOnboarding()
		}
		self.navigationController.viewControllers = [welcome]
	}

	private func showStudyGroupOnboarding() {
		let studyGroupVC = OnboardStudygroupViewController()
        studyGroupVC.onFinish = { [weak self] auth in
            self?.showUnixLoginOnboarding(schedule: auth)
        }
		self.navigationController.pushViewController(studyGroupVC, animated: true)
	}

    private func showUnixLoginOnboarding(schedule: ScheduleService.Auth?) {
        let unixLoginVC = OnboardUnixLoginViewController()
        unixLoginVC.onFinish = { [weak self] auth in
            self?.onFinish?(schedule, auth)
        }
        self.navigationController.pushViewController(unixLoginVC, animated: true)
    }
}
