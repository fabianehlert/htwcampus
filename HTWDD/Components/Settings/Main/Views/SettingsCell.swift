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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(viewModel: SettingsItemViewModel) {
        self.textLabel?.text = viewModel.title
        self.detailTextLabel?.text = viewModel.subtitle
    }
    
}
