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

	lazy var childCoordinators: [Coordinator] = [
        self.schedule,
        self.grades
    ]

	var rootViewController: UIViewController {
		return self.tabBarController
	}

	private lazy var schedule = ScheduleCoordinator()
	private lazy var grades = GradeCoordinator()

	// MARK: - Init

	init(window: UIWindow) {
		self.window = window

        let viewControllers = self.childCoordinators.map { c in
            c.rootViewController
        }
		self.tabBarController.setViewControllers(viewControllers, animated: false)

		self.window.rootViewController = self.rootViewController
		self.window.tintColor = UIColor.htw.blue
		self.window.makeKeyAndVisible()

        self.showOnboarding(animated: false)
	}

	private func showOnboarding(animated: Bool) {
		let onboarding = OnboardingCoordinator()
		onboarding.onFinish = { [weak self] coordinator, auth in

			print("Auth 🔑 --> \(String(describing: auth))")
			if let auth = auth {
				self?.schedule.auth = auth
                // TODO: Provide grade authentication as well!
                self?.grades.auth = .init(username: "", password: "")
			}

			if let coordinator = coordinator {
				coordinator.rootViewController.dismiss(animated: true, completion: {
					self?.removeChildCoordinator(coordinator)
				})
			}

		}

		self.addChildCoordinator(onboarding)
		self.rootViewController.present(onboarding.rootViewController, animated: animated, completion: nil)
	}
}
