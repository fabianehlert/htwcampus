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
		onboarding.onFinish = { [weak self, weak onboarding] schedule, grade in

            print("Schedule 🔑 --> \(String(describing: schedule))")
            print("Grade    🔑 --> \(String(describing: grade))")
            self?.schedule.auth = schedule
            self?.grades.auth = grade

            guard let coordinator = onboarding else {
                return
            }

            coordinator.rootViewController.dismiss(animated: true, completion: { [weak self] in
                self?.removeChildCoordinator(coordinator)
            })
		}

		self.addChildCoordinator(onboarding)
		self.rootViewController.present(onboarding.rootViewController, animated: animated, completion: nil)
	}
}
