//
//  GradeCollapsedCell.swift
//  HTWDD
//
//  Created by Kilian Költzsch on 12.04.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class GradeCollapsedCell: TableViewCell {

    enum Const {
        static let verticalMargin: CGFloat = 15
        static let colorViewHorizontalMargin: CGFloat = 10
        static let horizontalMargin: CGFloat = 10

        static let collapsedHeight: CGFloat = 60
        static let expandedHeight: CGFloat = 140
    }

    private lazy var colorView = UIView()
    private lazy var titleView = UILabel()
    private lazy var gradeView = UILabel()

    override func initialSetup() {
        super.initialSetup()

        self.gradeView.textAlignment = .right
        self.gradeView.textColor = UIColor.htw.mediumGrey
        self.gradeView.font = .systemFont(ofSize: 30, weight: .medium)

        self.titleView.font = .systemFont(ofSize: 20, weight: .regular)

        self.selectionStyle = .none

        [self.colorView, self.titleView, self.gradeView].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            // grade view
            self.gradeView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.horizontalMargin),
            self.gradeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.verticalMargin),
            self.gradeView.widthAnchor.constraint(equalToConstant: 60),
            self.gradeView.heightAnchor.constraint(equalToConstant: 30),

            // Color view
            self.colorView.leadingAnchor.constraint(equalTo: self.gradeView.trailingAnchor, constant: Const.horizontalMargin),
            self.colorView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.colorViewHorizontalMargin),
            self.colorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.colorViewHorizontalMargin),
            self.colorView.widthAnchor.constraint(equalToConstant: 5),

            // titleView
            self.titleView.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.horizontalMargin),
            self.titleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.horizontalMargin),
            self.titleView.centerYAnchor.constraint(equalTo: self.gradeView.centerYAnchor)
            ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorView.layer.cornerRadius = 2
    }
}

extension GradeCollapsedCell: Cell {
    func update(viewModel: GradeViewModel) {
        self.colorView.backgroundColor = viewModel.grade.state == .passed ? UIColor.green : .red
        self.titleView.text = viewModel.grade.text
        self.gradeView.text = viewModel.grade.mark?.description
    }
}

struct GradeViewModel: ViewModel {
    let grade: Grade

    init(model: Grade) {
        self.grade = model
    }
}
