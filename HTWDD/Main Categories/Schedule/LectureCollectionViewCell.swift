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
    init(model: Lecture) {

    }
}

class LectureCollectionViewCell: CollectionViewCell, Cell {

    override func initialSetup() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 3
    }

    func update(viewModel: LectureViewModel) {

    }

}
