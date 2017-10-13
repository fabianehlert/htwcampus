//
//  AppCoordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 13.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
	private var window: UIWindow
	private let tabBarController = TabBarController()

	var childCoordinators: [Coordinator] = []

	var rootViewController: UIViewController {
		return self.tabBarController
	}

	// MARK: - Init

	init(window: UIWindow) {
		self.window = window

		let schedule = ScheduleMainVC().inNavigationController()
		let grades = GradeMainVC().inNavigationController()

		self.tabBarController.setViewControllers([schedule, grades], animated: false)

		self.window.rootViewController = self.rootViewController
		self.window.makeKeyAndVisible()

		// TODO: Implement state check and show onboarding if necessary.
		self.showOnboarding()
	}

	private func showOnboarding() {
		let onboarding = OnboardingCoordinator()
		onboarding.delegate = self
		self.addChildCoordinator(onboarding)
		self.rootViewController.present(onboarding.rootViewController, animated: false, completion: nil)
	}
}

// MARK: - OnboardingCoordinatorDelegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
	func finishedOnboarding(coordinator: OnboardingCoordinator, success: Bool) {
		print("Onboarding was successful: \(success)")
		coordinator.rootViewController.dismiss(animated: true, completion: nil)
	}
}
