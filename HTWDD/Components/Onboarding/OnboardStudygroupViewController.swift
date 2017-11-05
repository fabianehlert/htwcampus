//
//  OnboardStudygroupViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class OnboardStudygroupViewController: OnboardDetailViewController<ScheduleService.Auth> {

    private struct State {
        var years: [StudyYear]?
        var majors: [StudyCourse]? {
            guard
                let year = self.year,
                let studyYear = self.years?.first(where: { $0.studyYear == year })
            else {
                return nil
            }
            return studyYear.studyCourses
        }
        var groups: [StudyGroup]? {
            guard
                let major = self.major,
                let studyMajor = self.majors?.first(where: { $0.studyCourse == major })
                else {
                    return nil
            }
            return studyMajor.studyGroups
        }
        
        var year: Int? {
            didSet {
                if oldValue != year {
                    self.major = nil
                    self.group = nil
                }
            }
        }
        var major: String? {
            didSet {
                if oldValue != major {
                    self.group = nil
                }
            }
        }
        var group: String?
        
        var completed: Bool {
            return self.year != nil && self.major != nil && self.group != nil
        }
    }
    private var state = Variable(State())
    
    private lazy var yearButton = ReactiveButton()
    private lazy var majorButton = ReactiveButton()
    private lazy var groupButton = ReactiveButton()

    private let network = Network()
    private let disposeBag = DisposeBag()
    
    // MARK: - ViewController lifecycle

    override func initialSetup() {
        let configureButton: (ReactiveButton) -> Void = {
            $0.isEnabled = false
            $0.setTitle("config.continueButtonText", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
            $0.backgroundColor = UIColor.htw.blue
            $0.layer.cornerRadius = 12
        }
        let buttons = [self.yearButton, self.majorButton, self.groupButton]
        buttons.forEach(configureButton)
        
        self.config = .init(title: Loca.Onboarding.Studygroup.title,
                            description: Loca.Onboarding.Studygroup.body,
                            contentViews: buttons,
                            contentViewsStackViewAxis: UILayoutConstraintAxis.horizontal,
                            notNowText: Loca.Onboarding.Studygroup.notnow,
                            continueButtonText: Loca.nextStep)

        super.initialSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stateObservable = self.state.asObservable()
        
        stateObservable
            .map({ $0.years != nil })
            .bind(to: self.yearButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        stateObservable
            .map({ $0.year != nil })
            .bind(to: self.majorButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        stateObservable
            .map({ $0.major != nil })
            .bind(to: self.groupButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        stateObservable
            .map({ $0.year?.description ?? Loca.Onboading.Studygroup.year })
            .bind(to: self.yearButton.rx.title())
            .disposed(by: self.disposeBag)
        
        stateObservable
            .map({ $0.major ?? Loca.Onboading.Studygroup.major })
            .bind(to: self.majorButton.rx.title())
            .disposed(by: self.disposeBag)
        
        stateObservable
            .map({ $0.group ?? Loca.Onboading.Studygroup.group })
            .bind(to: self.groupButton.rx.title())
            .disposed(by: self.disposeBag)
        
        stateObservable
            .map({ $0.completed })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.checkState()
            })
            .disposed(by: self.disposeBag)
        
        StudyYear.get(network: self.network).subscribe(onNext: { years in
            self.state.value.years = years
        }, onError: { [weak self] _ in
            self?.dismissOrPopViewController()
        }).disposed(by: self.disposeBag)
        
        // TODO: Change this!
        self.yearButton.rx
            .controlEvent(.touchUpInside)
            .map({ _ in 16 })
            .subscribe(onNext: { year in
                self.state.value.year = year
            })
            .disposed(by: self.disposeBag)
        
        self.majorButton.rx
            .controlEvent(.touchUpInside)
            .map({ _ in "044" })
            .subscribe(onNext: { major in
                self.state.value.major = major
            })
            .disposed(by: self.disposeBag)
        
        self.groupButton.rx
            .controlEvent(.touchUpInside)
            .map({ _ in "71" })
            .subscribe(onNext: { group in
                self.state.value.group = group
            })
            .disposed(by: self.disposeBag)
    }

    // MARK: - Overridden

    @objc
    override func continueBoarding() {
        let currentState = self.state.value
        guard
            let y = currentState.year,
            let m = currentState.major,
            let g = currentState.group
        else {
                self.onFinish?(nil)
                return
        }

        let group = ScheduleService.Auth(year: "\(y)", major: m, group: g)
        self.onFinish?(group)
    }

    override func shouldContinue() -> Bool {
        return self.state.value.completed
    }

}
