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

	var schedule: ScheduleMainVC
	var grades: GradeMainVC

	// MARK: - Init

	init(window: UIWindow) {
		self.window = window

		self.schedule = ScheduleMainVC()
		self.grades = GradeMainVC()

		self.tabBarController.setViewControllers([
			schedule.inNavigationController(),
			grades.inNavigationController()], animated: false)

		self.window.rootViewController = self.rootViewController
		self.window.makeKeyAndVisible()

		// TODO: Implement state check and show onboarding if necessary.
		self.showOnboarding(animated: false)
	}

	private func showOnboarding(animated: Bool) {
		let onboarding = OnboardingCoordinator()
		onboarding.delegate = self
		self.addChildCoordinator(onboarding)
		self.rootViewController.present(onboarding.rootViewController, animated: animated, completion: nil)
	}
}

// MARK: - OnboardingCoordinatorDelegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
	func finishedOnboarding(coordinator: OnboardingCoordinator, auth: ScheduleDataSource.Auth?) {
		if let auth = auth {
			print("Onboarding was successful: \(auth)")
			self.schedule.auth = auth
		} else {
			print("Onboarding was successful: nope")
		}
		coordinator.rootViewController.dismiss(animated: true, completion: nil)
	}
}
