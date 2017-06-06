//
//  GradeCell.swift
//  HTWDD
//
//  Created by Kilian Költzsch on 12.04.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class GradeCell: TableViewCell {
    var title: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }

    private let label = UILabel()

    override func initialSetup() {
        self.label.frame = self.contentView.bounds
//        self.label.textColor = .black
        self.label.textAlignment = .center
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.label.numberOfLines = 0
        self.label.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(self.label)
    }
}

extension GradeCell: Cell {
    func update(viewModel: GradeViewModel) {
        self.title = viewModel.grade.text
    }
}

struct GradeViewModel: ViewModel {
    let grade: Grade

    init(model: Grade) {
        self.grade = model
    }
}
