//
//  GradeCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 01.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class GradeCell: TableViewCell {

    enum Const {
        static let verticalMargin: CGFloat = 15
        static let verticalInnerItemMargin: CGFloat = 4
        static let colorViewHorizontalMargin: CGFloat = 10
        static let horizontalMargin: CGFloat = 10

        static let collapsedHeight: CGFloat = 60
        static let expandedHeight: CGFloat = 170

        static let markFontSize: CGFloat = 30
        static let titleFontSize: CGFloat = 20
        static let detailsFontSize: CGFloat = 18
    }

    private lazy var colorView = UIView()
    private lazy var titleView = UILabel()
    private lazy var markView = UILabel()

    private lazy var formView = UILabel()
    private lazy var creditsView = UILabel()
    private lazy var triesView = UILabel()
    private lazy var dateView = UILabel()
    private lazy var noteView = UILabel()

    private var detailLabels: [UILabel] {
        return [self.formView, self.creditsView, self.triesView, self.dateView, self.noteView]
    }

    override func initialSetup() {
        super.initialSetup()

        self.markView.textAlignment = .right
        self.markView.textColor = UIColor.htw.mediumGrey
        self.markView.font = .systemFont(ofSize: Const.markFontSize, weight: .medium)

        self.titleView.font = .systemFont(ofSize: Const.titleFontSize, weight: .regular)
        self.titleView.textColor = UIColor.htw.darkGrey

        self.formView.font = .systemFont(ofSize: Const.titleFontSize, weight: .regular)
        self.formView.textColor = UIColor.htw.darkGrey
        self.formView.textAlignment = .right

        self.detailLabels.forEach {
            $0.font = .systemFont(ofSize: Const.detailsFontSize, weight: .light)
            $0.textColor = UIColor.htw.lightGrey
        }

        self.creditsView.font = .systemFont(ofSize: Const.detailsFontSize, weight: .light)
        self.creditsView.textColor = UIColor.htw.lightGrey

        self.triesView.font = .systemFont(ofSize: Const.detailsFontSize, weight: .light)
        self.triesView.textColor = UIColor.htw.lightGrey

        self.dateView.font = .systemFont(ofSize: Const.detailsFontSize, weight: .light)
        self.dateView.textColor = UIColor.htw.lightGrey

        self.noteView.font = .systemFont(ofSize: Const.detailsFontSize, weight: .light)
        self.noteView.textColor = UIColor.htw.lightGrey

        self.selectionStyle = .none

        self.prepareForReuse()

        [self.colorView, self.titleView, self.markView, self.formView, self.creditsView, self.triesView, self.dateView, self.noteView].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            // grade view
            self.markView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.horizontalMargin),
            self.markView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.verticalMargin),
            self.markView.widthAnchor.constraint(equalToConstant: 60),
            self.markView.heightAnchor.constraint(equalToConstant: 30),

            // Color view
            self.colorView.leadingAnchor.constraint(equalTo: self.markView.trailingAnchor, constant: Const.horizontalMargin),
            self.colorView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.colorViewHorizontalMargin),
            self.colorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.colorViewHorizontalMargin),
            self.colorView.widthAnchor.constraint(equalToConstant: 5),

            // titleView
            self.titleView.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.horizontalMargin),
            self.titleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.horizontalMargin),
            self.titleView.centerYAnchor.constraint(equalTo: self.markView.centerYAnchor),

            // form
            self.formView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.verticalMargin),
            self.formView.trailingAnchor.constraint(equalTo: self.markView.trailingAnchor),

            // credits
            self.creditsView.leadingAnchor.constraint(equalTo: self.titleView.leadingAnchor),

            // tries
            self.triesView.leadingAnchor.constraint(equalTo: self.creditsView.leadingAnchor),
            self.triesView.topAnchor.constraint(equalTo: self.creditsView.bottomAnchor, constant: Const.verticalInnerItemMargin),

            // date
            self.dateView.leadingAnchor.constraint(equalTo: self.creditsView.leadingAnchor),
            self.dateView.topAnchor.constraint(equalTo: self.triesView.bottomAnchor, constant: Const.verticalInnerItemMargin),

            // note
            self.noteView.leadingAnchor.constraint(equalTo: self.creditsView.leadingAnchor),
            self.noteView.topAnchor.constraint(equalTo: self.dateView.bottomAnchor, constant: Const.verticalInnerItemMargin),
            self.noteView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.verticalMargin)
            ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorView.layer.cornerRadius = 2
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
        self.titleView.text = viewModel.title
        self.markView.text = viewModel.mark
        self.formView.text = viewModel.form
        self.creditsView.text = viewModel.credits
        self.triesView.text = viewModel.tries
        self.dateView.text = viewModel.date
        self.noteView.text = viewModel.note
    }
}
