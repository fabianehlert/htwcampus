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
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.label.frame = self.contentView.bounds
        self.label.textAlignment = .center
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.label)
    }

    func update(viewModel: LectureViewModel) {
        self.label.text = viewModel.model.tag
    }

}

extension LectureCollectionViewCell: Highlightable {

    func highlight(animated: Bool) {
        let animations: () -> Void = {
            self.contentView.backgroundColor = .blue
            self.label.textColor = .white
        }
        if !animated {
            animations()
        } else {
            UIView.animate(withDuration: 0.1, animations: animations)
        }
    }

    func unhighlight(animated: Bool) {
        let animations: () -> Void = {
            self.contentView.backgroundColor = .white
            self.label.textColor = .black
        }
        if !animated {
            animations()
        } else {
            UIView.animate(withDuration: 0.1, animations: animations)
        }
    }

}
