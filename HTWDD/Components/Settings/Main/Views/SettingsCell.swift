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
        static let maximumSubtitleWidth: CGFloat = 100
    }
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.htw.grey
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var imageWidthConstraint: NSLayoutConstraint = {
        return self.thumbnailImageView.widthAnchor.constraint(equalToConstant: Const.imageSize)
    }()
    
    private lazy var imageSpaceConstraint: NSLayoutConstraint = {
        return self.titleLabel.leadingAnchor.constraint(equalTo: self.thumbnailImageView.trailingAnchor,
                                                        constant: Const.margin)
    }()
    
    // MARK: - Init
    
    override func initialSetup() {
        super.initialSetup()
        
        self.accessoryType = .disclosureIndicator
        
        self.contentView.add(self.thumbnailImageView, self.titleLabel, self.subtitleLabel) { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.thumbnailImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.thumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.thumbnailImageView.heightAnchor.constraint(equalToConstant: Const.imageSize),
            self.imageWidthConstraint,
            
            self.imageSpaceConstraint,
            
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.margin),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.subtitleLabel.leadingAnchor, constant: -Const.margin),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.margin),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.margin),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            self.subtitleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.margin),
            self.subtitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: Const.maximumSubtitleWidth)
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
