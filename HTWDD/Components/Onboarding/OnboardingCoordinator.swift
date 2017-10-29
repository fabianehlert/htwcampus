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

	var onFinish: ((OnboardingCoordinator?, ScheduleService.Auth?) -> Void)?

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
		studyGroupVC.onContinue = { [weak self] vc, auth in
			self?.onFinish?(self, auth)
		}
		studyGroupVC.onSkip = { [weak self] vc in
			self?.onFinish?(self, nil)
		}
		self.navigationController.pushViewController(studyGroupVC, animated: true)
	}
}
