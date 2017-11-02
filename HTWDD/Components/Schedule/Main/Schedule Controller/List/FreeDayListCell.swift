//
//  FreeDayListCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 01.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

extension Event: Identifiable {}
struct FreeDayViewModel: ViewModel {
    let title: String
    init(model: Event) {
        self.title = model.name
    }
}

class FreeDayListCell: FlatCollectionViewCell, Cell {
    
    enum Const {
        static let textColor = UIColor.black
        static let margin: CGFloat = 10
    }
    
    private let label = UILabel()
    
    override func initialSetup() {
        super.initialSetup()
        self.label.font = .systemFont(ofSize: 18, weight: .medium)
        self.label.textAlignment = .center
        self.label.textColor = Const.textColor
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.backgroundColor = .white
        
        self.contentView.addSubview(self.label)
        
        // TODO: inject this!
        let widthConstraint = self.contentView.widthAnchor.constraint(equalToConstant: 351)
        
        NSLayoutConstraint.activate([
            widthConstraint,
            
            self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.margin),
            self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),
            self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.margin),
            self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.margin),
            self.label.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
            ])
    }
    
    func update(viewModel: FreeDayViewModel) {
        self.label.text = viewModel.title
    }
    
}
