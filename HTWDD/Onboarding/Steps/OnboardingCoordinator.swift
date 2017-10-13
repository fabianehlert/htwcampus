//
//  OnboardingCoordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

protocol OnboardingCoordinatorDelegate: class {
	func finishedOnboarding(coordinator: OnboardingCoordinator, success: Bool)
}

class OnboardingCoordinator: Coordinator {
	weak var delegate: OnboardingCoordinatorDelegate?

	var childCoordinators: [Coordinator] = []

	private lazy var navigationController: NavigationController = {
		let navigationController = NavigationController()
		navigationController.navigationBar.isHidden = true
		return navigationController
	}()

	var rootViewController: UIViewController {
		return self.navigationController
	}

	// MARK: - Init

	init() {
		let welcome = OnboardWelcomeViewController()
		welcome.delegate = self
		self.navigationController.viewControllers = [welcome]
	}

	private func showStudyGroupOnboarding() {
		let studyGroupVC = OnboardStudygroupViewController()
		studyGroupVC.delegate = self
		self.navigationController.pushViewController(studyGroupVC, animated: true)
	}
}

// MARK: - OnboardWelcomeViewControllerDelegate
extension OnboardingCoordinator: OnboardWelcomeViewControllerDelegate {
    func didTapContinue(_ vc: OnboardWelcomeViewController) {
		self.showStudyGroupOnboarding()
    }
}

// MARK: - OnboardStudygroupViewControllerDelegate
extension OnboardingCoordinator: OnboardStudygroupViewControllerDelegate {
	func didTapContinue(_ vc: OnboardStudygroupViewController) {
		self.delegate?.finishedOnboarding(coordinator: self, success: true)
	}

	func didTapSkip(_ vc: OnboardStudygroupViewController) {
		self.delegate?.finishedOnboarding(coordinator: self, success: false)
	}
}
