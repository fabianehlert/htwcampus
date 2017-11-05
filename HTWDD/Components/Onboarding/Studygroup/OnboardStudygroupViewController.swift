//
//  OnboardStudygroupViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class OnboardStudygroupViewController: OnboardDetailViewController<ScheduleService.Auth>, AnimatedViewControllerTransitionDataSource {

    private struct State {
        var years: [StudyYear]?
        var majors: [StudyCourse]? {
            guard
                let year = self.year,
                let studyYear = self.years?.first(where: { $0.studyYear == year.studyYear })
            else {
                return nil
            }
            return studyYear.studyCourses
        }
        var groups: [StudyGroup]? {
            guard
                let major = self.major,
                let studyMajor = self.majors?.first(where: { $0.studyCourse == major.studyCourse })
                else {
                    return nil
            }
            return studyMajor.studyGroups
        }
        
        var year: StudyYear? {
            didSet {
                if oldValue?.studyYear != year?.studyYear {
                    self.major = nil
                    self.group = nil
                }
            }
        }
        var major: StudyCourse? {
            didSet {
                if oldValue?.studyCourse != major?.studyCourse {
                    self.group = nil
                }
            }
        }
        var group: StudyGroup?
        
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
            .map({ $0.year?.studyYear.description ?? Loca.Onboarding.Studygroup.year })
            .bind(to: self.yearButton.rx.title())
            .disposed(by: self.disposeBag)
        
        stateObservable
            .map({ $0.major?.studyCourse ?? Loca.Onboarding.Studygroup.major })
            .bind(to: self.majorButton.rx.title())
            .disposed(by: self.disposeBag)
        
        stateObservable
            .map({ $0.group?.studyGroup ?? Loca.Onboarding.Studygroup.group })
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
            .flatMap({ [weak self] _ -> Observable<StudyYear> in
                guard let `self` = self, let years = self.state.value.years else {
                    return Observable.empty()
                }
                return OnboardStudygroupSelectionController.show(controller: self, data: years)
            })
            .subscribe(onNext: { [weak self] studyYear in
                self?.state.value.year = studyYear
            })
            .disposed(by: self.disposeBag)
        
        
        self.majorButton.rx
            .controlEvent(.touchUpInside)
            .flatMap({ [weak self] _ -> Observable<StudyCourse> in
                guard let `self` = self, let majors = self.state.value.majors else {
                    return Observable.empty()
                }
                return OnboardStudygroupSelectionController.show(controller: self, data: majors)
            })
            .subscribe(onNext: { major in
                self.state.value.major = major
            })
            .disposed(by: self.disposeBag)
        
        self.groupButton.rx
            .controlEvent(.touchUpInside)
            .flatMap({ [weak self] _ -> Observable<StudyGroup> in
                guard let `self` = self, let groups = self.state.value.groups else {
                    return Observable.empty()
                }
                return OnboardStudygroupSelectionController.show(controller: self, data: groups)
            })
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
            let y = currentState.year?.studyYear.description,
            let m = currentState.major?.studyCourse,
            let g = currentState.group?.studyGroup
        else {
                self.onFinish?(nil)
                return
        }

        let group = ScheduleService.Auth(year: y, major: m, group: g)
        self.onFinish?(group)
    }

    override func shouldContinue() -> Bool {
        return self.state.value.completed
    }
    
}
