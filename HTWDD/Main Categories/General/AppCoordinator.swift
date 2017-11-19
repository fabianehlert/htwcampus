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
		
        self.showOnboarding(animated: false)		
	}

    private func injectAuthentication(schedule: ScheduleService.Auth?, grade: GradeService.Auth?) {
        self.schedule.auth = schedule
        self.exams.auth = schedule
        self.grades.auth = grade
        self.settings.scheduleAuth = schedule
        self.settings.gradeAuth = grade
    }

	private func showOnboarding(animated: Bool) {

        self.loadPersistedAuth { [weak self] schedule, grade in

            // If one of them has already been saved
            if schedule != nil || grade != nil {
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
	
}

extension AppCoordinator: SettingsCoordinatorDelegate {
    
    func deleteAllData() {
        self.persistenceService.clear()
        self.schedule.auth = nil
        self.exams.auth = nil
        self.grades.auth = nil
        self.showOnboarding(animated: true)
    }
    
    func triggerScheduleOnboarding(completion: @escaping (ScheduleService.Auth) -> Void) {
        self.triggerOnboarding(.studygroup) { [weak self] schedule, _ in
            guard let auth = schedule else {
                return
            }
            self?.schedule.auth = auth
            self?.persistenceService.save(auth)
            completion(auth)
        }
    }
    
    func triggerGradeOnboarding(completion: @escaping (GradeService.Auth) -> Void) {
        self.triggerOnboarding(.unixlogin) { [weak self] _, auth in
            guard let auth = auth else {
                return
            }
            self?.grades.auth = auth
            self?.persistenceService.save(auth)
            completion(auth)
        }
    }
    
    private func triggerOnboarding(_ onboarding: OnboardingCoordinator.Onboarding, completion: @escaping (ScheduleService.Auth?, GradeService.Auth?) -> Void) {
        let onboarding = OnboardingCoordinator(onboardings: [onboarding])
        onboarding.onFinish = { [weak onboarding] response in
            completion(response.schedule, response.grade)
            onboarding?.rootViewController.dismiss(animated: true, completion: nil)
        }
        self.addChildCoordinator(onboarding)
        self.rootViewController.present(onboarding.rootViewController, animated: true, completion: nil)
    }
    
}
