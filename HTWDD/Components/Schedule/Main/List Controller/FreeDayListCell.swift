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
    
    let label = UILabel()
    
    override func initialSetup() {
        super.initialSetup()
		
		self.isHighlightable = false
		
        self.label.font = .systemFont(ofSize: 18, weight: .medium)
        self.label.textAlignment = .center
        self.label.textColor = Const.textColor
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.backgroundColor = .white
        
        self.contentView.addSubview(self.label)
        
        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            ])
    }
    
    func update(viewModel: FreeDayViewModel) {
        self.label.text = viewModel.title
    }
    
}
