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
        self.subtitle = model.studyGroup
    }
}

class OnboardingStudygroupSelectionCell: FlatCollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.htw.textHeadline
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = UIColor.htw.mediumGrey
        label.textAlignment = .center
        return label
    }()
    
    override func initialSetup() {
        super.initialSetup()
        
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor)
            ])
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
