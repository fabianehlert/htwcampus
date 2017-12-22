//
//  SwitchCell.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 22.12.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

struct SwitchViewModel: ViewModel {
    let title: String
    let on: Bool
    
    init(model: AppLecture) {
        self.title = model.lecture.name
        self.on = !model.hidden
    }
}

class SwitchCell: TableViewCell, Cell {
 
    enum Const {
        static let margin: CGFloat = 15
        static let verticalMargin: CGFloat = 4
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var activeSwitch: UISwitch = {
        let s = UISwitch()
        return s
    }()
    
    // MARK: - Init
    
    override func initialSetup() {
        super.initialSetup()
        
        self.selectionStyle = .none
        
        let views: [UIView] = [self.titleLabel, self.activeSwitch]
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                     constant: Const.margin),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                 constant: Const.verticalMargin),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                    constant: -Const.verticalMargin),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.activeSwitch.leadingAnchor,
                                                      constant: -Const.margin),
            
            self.activeSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),
            self.activeSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }

    func update(viewModel: SwitchViewModel) {
        self.titleLabel.text = viewModel.title
        self.activeSwitch.isOn = viewModel.on
    }

}
