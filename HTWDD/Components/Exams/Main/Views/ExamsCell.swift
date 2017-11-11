//
//  ExamsCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 06.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

struct ExamsViewModel: ViewModel {
    let title: String
    init(model: Exam) {
        self.title = model.title
    }
}

class ExamsCell: FlatCollectionViewCell, Cell {
    
    enum Const {
        static let margin: CGFloat = 15
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.htw.mediumGrey
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func initialSetup() {
        super.initialSetup()
        self.contentView.addSubview(self.titleLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.margin),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.margin),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.margin)
        ])
    }
    
    func update(viewModel: ExamsViewModel) {
        self.titleLabel.text = viewModel.title
    }
    
}

