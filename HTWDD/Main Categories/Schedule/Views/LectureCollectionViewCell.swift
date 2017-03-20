//
//  LectureCollectionViewCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

extension Lecture: Identifiable {}

struct LectureViewModel: ViewModel {
    let model: Lecture
    init(model: Lecture) {
        self.model = model
    }
}

class LectureCollectionViewCell: CollectionViewCell, Cell {

    let label = UILabel()

    override func initialSetup() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        self.label.frame = self.contentView.bounds
        self.label.textAlignment = .center
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.label)
    }

    func update(viewModel: LectureViewModel) {
        label.text = viewModel.model.tag
    }

}

extension LectureCollectionViewCell: Highlightable {

    func highlight(animated: Bool) {

    }

    func unhighlight(animated: Bool) {

    }

}
