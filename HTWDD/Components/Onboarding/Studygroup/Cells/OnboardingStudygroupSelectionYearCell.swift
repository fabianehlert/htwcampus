//
//  OnboardingStudygroupSelectionYearCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

struct StudyYearViewModel: ViewModel {
    let title: String
    
    init(model: StudyYear) {
        self.title = (model.studyYear + 2000).description
    }
}

struct StudyCourseViewModel: ViewModel {
    let title: String
    let subtitle: String
    
    init(model: StudyCourse) {
        self.title = model.name
        self.subtitle = model.studyCourse
    }
}

struct StudyGroupViewModel: ViewModel {
    let title: String
    let subtitle: String
    
    init(model: StudyGroup) {
        self.title = model.name
        let degree: String
        switch model.degree {
        case .bachelor: degree = Loca.Onboarding.Studygroup.degree.bachelor
        case .diplom: degree = Loca.Onboarding.Studygroup.degree.diplom
        case .master: degree = Loca.Onboarding.Studygroup.degree.master
        }
        self.subtitle = "\(model.studyGroup) - \(degree)"
    }
}

class OnboardingStudygroupSelectionCell: FlatCollectionViewCell {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override func initialSetup() {
        super.initialSetup()
        
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        stackView.frame = self.contentView.bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(stackView)
    }
}

class OnboardingStudygroupSelectionYearCell: OnboardingStudygroupSelectionCell, Cell {
    func update(viewModel: StudyYearViewModel) {
        self.titleLabel.text = viewModel.title
        self.subtitleLabel.isHidden = true
    }
}

class OnboardingStudygroupSelectionCourseCell: OnboardingStudygroupSelectionCell, Cell {
    func update(viewModel: StudyCourseViewModel) {
        self.titleLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
    }
}

class OnboardingStudygroupSelectionGroupCell: OnboardingStudygroupSelectionCell, Cell {
    func update(viewModel: StudyGroupViewModel) {
        self.titleLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
    }
}
