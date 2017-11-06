//
//  MealCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

struct MealViewModel: ViewModel {
    let meal: Meal
    init(model: Meal) {
        self.meal = model
    }
}

class MealCell: FlatCollectionViewCell, Cell {

    lazy var label = UILabel()

    override func initialSetup() {
        super.initialSetup()

        self.label.frame = self.bounds
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.label)
    }

    func update(viewModel: MealViewModel) {
        self.label.text = viewModel.meal.title
    }

}
