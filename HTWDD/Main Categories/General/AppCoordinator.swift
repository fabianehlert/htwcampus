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
        self.grades,
        self.canteen
    ]

	var rootViewController: UIViewController {
		return self.tabBarController
	}

    let appContext = AppContext()

    private lazy var schedule = ScheduleCoordinator(context: self.appContext)
    private lazy var grades = GradeCoordinator(context: self.appContext)
    private lazy var canteen = CanteenCoordinator(context: self.appContext)

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

//        self.showOnboarding(animated: false)
	}

	private func showOnboarding(animated: Bool) {
		let onboarding = OnboardingCoordinator()
		onboarding.onFinish = { [weak self, weak onboarding] schedule, grade in
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
