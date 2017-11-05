//
//  AppCoordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 13.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: Coordinator {
	private var window: UIWindow
	private let tabBarController = TabBarController()

	lazy var childCoordinators: [Coordinator] = [
        self.schedule,
		self.exams,
        self.grades,
        self.canteen,
		self.settings
    ]

	var rootViewController: UIViewController {
		return self.tabBarController
	}

    let appContext = AppContext()
    private let persistenceService = PersistenceService()

    private lazy var schedule = ScheduleCoordinator(context: self.appContext)
	private lazy var exams = ExamsCoordinator(context: self.appContext)
	private lazy var grades = GradeCoordinator(context: self.appContext)
    private lazy var canteen = CanteenCoordinator(context: self.appContext)
    private lazy var settings = SettingsCoordinator(context: self.appContext, delegate: self)

    private let disposeBag = DisposeBag()

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

		self.stylizeUI()
		
        self.showOnboarding(animated: false)		
	}

    private func injectAuthentication(schedule: ScheduleService.Auth?, grade: GradeService.Auth?) {
        self.schedule.auth = schedule
        self.grades.auth = grade
    }

	private func showOnboarding(animated: Bool) {

        self.loadPersistedAuth { [weak self] schedule, grade in

            // TODO: Maybe we like to inject them seperately
            if let schedule = schedule, let grade = grade {
                self?.injectAuthentication(schedule: schedule, grade: grade)
                return
            }

            let onboarding = OnboardingCoordinator()
            onboarding.onFinish = { [weak self, weak onboarding] res in
                self?.injectAuthentication(schedule: res.schedule, grade: res.grade)
                if let grade = res.grade { self?.persistenceService.save(grade) }
                if let schedule = res.schedule { self?.persistenceService.save(schedule) }

                guard let coordinator = onboarding else {
                    return
                }

                coordinator.rootViewController.dismiss(animated: true, completion: { [weak self] in
                    self?.removeChildCoordinator(coordinator)
                })
            }

            self?.addChildCoordinator(onboarding)
            self?.rootViewController.present(onboarding.rootViewController, animated: animated, completion: nil)
        }

	}

    private func loadPersistedAuth(completion: @escaping (ScheduleService.Auth?, GradeService.Auth?) -> Void) {
        self.persistenceService.load()
            .take(1)
            .subscribe(onNext: { res in
                    completion(res.schedule, res.grades)
            }, onError: { _ in
                completion(nil, nil)
            })
            .disposed(by: self.disposeBag)
    }
	
	// MARK: - UI Apperance
	
	private func stylizeUI() {
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().barTintColor = UIColor.htw.blue
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
		if #available(iOS 11.0, *) { UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white] }
	}
}

extension AppCoordinator: SettingsCoordinatorDelegate {
    
    func deleteAllData() {
        self.persistenceService.clear()
        self.schedule.auth = nil
        self.grades.auth = nil
        self.showOnboarding(animated: true)
    }
    
}
