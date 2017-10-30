//
//  OnboardingCoordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    enum Onboarding: Int {
        case welcome = 0
        case studygroup = 1
        case unixlogin = 2

        static let all: [Onboarding] = [.welcome, .studygroup, .unixlogin]
    }

    var childCoordinators: [Coordinator] = []

    private lazy var navigationController: NavigationController = {
        let navigationController = NavigationController()
        navigationController.navigationBar.isHidden = true
        return navigationController
    }()

    var rootViewController: UIViewController {
        return self.navigationController
    }

    class Response {
        var schedule: ScheduleService.Auth?
        var grade: GradeService.Auth?
    }

    var onFinish: ((Response) -> Void)?

    // MARK: - Init

    private let onboardings: [Onboarding]
    init(onboardings: [Onboarding] = Onboarding.all) {
        self.onboardings = onboardings
        self.startFlow()
    }

    private func startFlow() {
        let functions = self.onboardings.flatMap { self.onboardingFunctions[$0] }
        let response = Response()
        self.callFunctions(response: response, functions: functions) { [weak self] in
            self?.onFinish?(response)
        }
    }

    private func callFunctions(response: Response, functions: [OnboardingFunction], completion: @escaping () -> Void) {
        guard let first = functions.first else {
            return completion()
        }
        first(response) { [weak self] in
            self?.callFunctions(response: response, functions: Array(functions.dropFirst()), completion: completion)
        }
    }

    typealias OnboardingFunction = (Response, @escaping () -> Void) -> Void
    lazy var onboardingFunctions: [Onboarding: OnboardingFunction] = [
        .welcome: self.showWelcomeOnboarding,
        .studygroup: self.showStudyGroupOnboarding,
        .unixlogin: self.showUnixLoginOnboarding
    ]

    private func showWelcomeOnboarding(response: Response, next: @escaping () -> Void) {
        let welcome = OnboardWelcomeViewController()
        welcome.onContinue = { vc in
            next()
        }
        self.navigationController.viewControllers = [welcome]
    }

    private func showStudyGroupOnboarding(response: Response, next: @escaping () -> Void) {
        let studyGroupVC = OnboardStudygroupViewController()
        studyGroupVC.onFinish = { auth in
            response.schedule = auth
            next()
        }
        self.navigationController.pushViewController(studyGroupVC, animated: true)
    }

    private func showUnixLoginOnboarding(response: Response, next: @escaping () -> Void) {
        let unixLoginVC = OnboardUnixLoginViewController()
        unixLoginVC.onFinish = { auth in
            response.grade = auth
            next()
        }
        self.navigationController.pushViewController(unixLoginVC, animated: true)
    }
}
