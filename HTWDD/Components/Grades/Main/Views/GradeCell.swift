//
//  GradeCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 01.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class GradeCell: FlatCollectionViewCell {

    enum Const {
        static let verticalMargin: CGFloat = 15
        static let verticalInnerItemMargin: CGFloat = 2
        static let colorViewHorizontalMargin: CGFloat = 10
        static let horizontalMargin: CGFloat = 10
        static let horizontalInnerItemMargin: CGFloat = 6

        static let collapsedHeight: CGFloat = 60
        static let expandedHeight: CGFloat = 156

        static let markFontSize: CGFloat = 25
        static let titleFontSize: CGFloat = 18
        static let detailsFontSize: CGFloat = 15
        static let badgeFontSize: CGFloat = 13
    }

    private lazy var colorView = UIView()
    
    private lazy var gradeLabel = UILabel()
    private lazy var titleLabel = UILabel()
    
    private lazy var typeBadge = BadgeLabel()
    private lazy var creditsBadge = BadgeLabel()
    private lazy var stateLabel = UILabel()
    private lazy var triesLabel = UILabel()
    private lazy var noteLabel = UILabel()

    private var detailLabels: [UILabel] {
        return [self.typeBadge, self.creditsBadge, self.stateLabel, self.triesLabel, self.noteLabel]
    }

    override func initialSetup() {
        super.initialSetup()

        self.gradeLabel.textAlignment = .right
        self.gradeLabel.font = .systemFont(ofSize: Const.markFontSize, weight: .medium)
        self.gradeLabel.textColor = UIColor.htw.mediumGrey
        
        self.titleLabel.font = .systemFont(ofSize: Const.titleFontSize, weight: .medium)
        self.titleLabel.textColor = UIColor.htw.textHeadline

        self.detailLabels.forEach {
            $0.font = .systemFont(ofSize: Const.detailsFontSize, weight: .light)
            $0.textColor = UIColor.htw.mediumGrey
        }
        
        self.typeBadge.font = .systemFont(ofSize: Const.badgeFontSize, weight: .semibold)
        self.typeBadge.textColor = UIColor.htw.textHeadline
        self.typeBadge.backgroundColor = UIColor(hex: 0xE8E8E8)
        
        self.creditsBadge.font = .systemFont(ofSize: Const.badgeFontSize, weight: .semibold)
        self.creditsBadge.textColor = UIColor.htw.textHeadline
        self.creditsBadge.backgroundColor = UIColor(hex: 0xCFCFCF)

        self.triesLabel.font = .systemFont(ofSize: Const.detailsFontSize, weight: .medium)
        self.noteLabel.font = .systemFont(ofSize: Const.detailsFontSize, weight: .medium)
        self.stateLabel.font = .systemFont(ofSize: Const.detailsFontSize, weight: .medium)

        self.prepareForReuse()
        
        self.contentView.add(self.colorView,
                             self.gradeLabel,
                             self.titleLabel,
                             self.typeBadge,
                             self.creditsBadge,
                             self.triesLabel,
                             self.stateLabel,
                             self.noteLabel) { v in
                                v.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            // Grade Label
            self.gradeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.horizontalMargin),
            self.gradeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.verticalMargin),
            self.gradeLabel.widthAnchor.constraint(equalToConstant: 60),
            self.gradeLabel.heightAnchor.constraint(equalToConstant: 30),

            // Color View
            self.colorView.leadingAnchor.constraint(equalTo: self.gradeLabel.trailingAnchor, constant: Const.horizontalMargin),
            self.colorView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.colorViewHorizontalMargin),
            self.colorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.colorViewHorizontalMargin),
            self.colorView.widthAnchor.constraint(equalToConstant: 5),

            // Title Label
            self.titleLabel.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.horizontalMargin),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.horizontalMargin),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.gradeLabel.centerYAnchor),
            
            // Type Badge
            self.typeBadge.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            
            // Credits Badge
            self.creditsBadge.leadingAnchor.constraint(equalTo: self.typeBadge.trailingAnchor, constant: Const.horizontalInnerItemMargin),
            self.creditsBadge.topAnchor.constraint(equalTo: self.typeBadge.topAnchor),
            
            // State
            self.stateLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.stateLabel.topAnchor.constraint(equalTo: self.typeBadge.bottomAnchor, constant: Const.verticalInnerItemMargin*2),

            // Tries
            self.triesLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.triesLabel.topAnchor.constraint(equalTo: self.stateLabel.bottomAnchor, constant: Const.verticalInnerItemMargin),
            
            // Note
            self.noteLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.noteLabel.topAnchor.constraint(equalTo: self.triesLabel.bottomAnchor, constant: Const.verticalInnerItemMargin),
            self.noteLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.verticalMargin)
        ])
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorView.layer.cornerRadius = self.colorView.width / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.updatedExpanded(false)
    }

    func updatedExpanded(_ expanded: Bool) {
        self.detailLabels
            .forEach({ $0.isHidden = !expanded })
    }
}

extension GradeCell: Cell {
    func update(viewModel: GradeViewModel) {
        self.colorView.backgroundColor = viewModel.color
        
        self.gradeLabel.text = viewModel.mark
        self.titleLabel.text = viewModel.title

        self.typeBadge.text = viewModel.form
        self.creditsBadge.text = viewModel.credits

        self.stateLabel.text = viewModel.state
        self.triesLabel.text = viewModel.combinedTries
        self.noteLabel.text = viewModel.note
    }
}
