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

	private var schedule: ScheduleMainVC
	private var grades: GradeMainVC

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

		// self.showOnboarding(animated: false)
	}

	private func showOnboarding(animated: Bool) {
		let onboarding = OnboardingCoordinator()
		onboarding.onFinish = { [weak self] coordinator, auth in

			print("Auth 🔑 --> \(String(describing: auth))")
			if let auth = auth {
				self?.schedule.auth = auth
			}

			if let coordinator = coordinator {
				coordinator.rootViewController.dismiss(animated: true, completion: nil)
				self?.removeChildCoordinator(coordinator)
			}

		}

		self.addChildCoordinator(onboarding)
		self.rootViewController.present(onboarding.rootViewController, animated: animated, completion: nil)
	}
}
