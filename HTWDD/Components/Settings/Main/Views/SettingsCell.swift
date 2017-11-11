//
//  SettingsCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

struct SettingsItem: Identifiable {
    let title: String
    let action: () -> ()
    
    init(title: String, action: @escaping @autoclosure () -> ()) {
        self.title = title
        self.action = action
    }
}

struct SettingsItemViewModel: ViewModel {
    let title: String
    init(model: SettingsItem) {
        self.title = model.title
    }
}

class SettingsCell: TableViewCell, Cell {
    
    enum Const {
        static let margin: CGFloat = 15
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.htw.mediumGrey
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func initialSetup() {
        super.initialSetup()
        
        self.contentView.addSubview(self.titleLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.margin),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            ])
    }
    
    func update(viewModel: SettingsItemViewModel) {
        self.titleLabel.text = viewModel.title
    }
    
}
