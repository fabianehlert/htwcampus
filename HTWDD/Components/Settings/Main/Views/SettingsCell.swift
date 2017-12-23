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
    let thumbnail: UIImage?
    let action: () -> ()
    
    init(title: String, subtitle: String? = nil, thumbnail: UIImage? = nil, action: @escaping @autoclosure () -> ()) {
        self.title = title
        self.subtitle = subtitle
        self.thumbnail = thumbnail
        self.action = action
    }
}

struct SettingsItemViewModel: ViewModel {
    let title: String
    let subtitle: String?
    let thumbnail: UIImage?
    
    init(model: SettingsItem) {
        self.title = model.title
        self.subtitle = model.subtitle
        self.thumbnail = model.thumbnail
    }
}

class SettingsCell: TableViewCell, Cell {
    
    enum Const {
        static let margin: CGFloat = 15
        static let imageSize: CGFloat = 25
    }
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var stackView = UIStackView()
    
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

    private lazy var imageWidthConstraint: NSLayoutConstraint = {
        return self.thumbnailImageView.widthAnchor.constraint(equalToConstant: Const.imageSize)
    }()
    
    private lazy var imageSpaceConstraint: NSLayoutConstraint = {
        return self.stackView.leadingAnchor.constraint(equalTo: self.thumbnailImageView.trailingAnchor,
                                                       constant: Const.margin)
    }()
    
    // MARK: - Init
    
    override func initialSetup() {
        super.initialSetup()
        
        self.accessoryType = .disclosureIndicator
        
        self.contentView.addSubview(self.thumbnailImageView)
        
        self.stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        self.stackView.axis = .horizontal
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.thumbnailImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.thumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                             constant: Const.margin),
            self.thumbnailImageView.heightAnchor.constraint(equalToConstant: Const.imageSize),
            self.imageWidthConstraint,
            
            self.imageSpaceConstraint,
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                constant: Const.margin),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                   constant: -Const.margin)
        ])
    }
    
    func update(viewModel: SettingsItemViewModel) {
        self.titleLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
        self.thumbnailImageView.image = viewModel.thumbnail
        
        self.imageWidthConstraint.constant = viewModel.thumbnail != nil ? Const.imageSize : 0
        self.imageSpaceConstraint.constant = viewModel.thumbnail != nil ? Const.margin : 0
        
        self.contentView.layoutIfNeeded()
    }
    
}
