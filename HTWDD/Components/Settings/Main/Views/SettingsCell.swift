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
    let subtitle: String?
    let action: () -> ()
    
    init(title: String, subtitle: String? = nil, action: @escaping @autoclosure () -> ()) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
}

struct SettingsItemViewModel: ViewModel {
    let title: String
    let subtitle: String?
    init(model: SettingsItem) {
        self.title = model.title
        self.subtitle = model.subtitle
    }
}

class SettingsCell: TableViewCell, Cell {
    
    enum Const {
        static let margin: CGFloat = 15
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.htw.grey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init
    
    override func initialSetup() {
        super.initialSetup()
        
        self.accessoryType = .disclosureIndicator
        
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        stackView.axis = .horizontal
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                               constant: Const.margin),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                           constant: Const.margin),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                              constant: -Const.margin)
        ])
    }
    
    func update(viewModel: SettingsItemViewModel) {
        self.titleLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
    }
    
}
