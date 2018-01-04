//
//  LectureCollectionViewCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class LectureCollectionViewCell: CollectionViewCell, Cell {

    enum Const {
        static let margin: CGFloat = 4

        static let highlightedScale: CGFloat = 0.97

        static let shadowRadius: CGFloat = 2
        static let highlightedShadowRadius: CGFloat = 1

        static let shadowOpacity: Float = 0.16
        static let highlightedShadowOpacity: Float = 0.2
    }

	var isHighlightable: Bool = true
	
	// MARK: - UI

    let colorView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.htw.textHeadline
		label.textAlignment = .left
		label.numberOfLines = 1
		label.lineBreakMode = .byCharWrapping
        return label
    }()

	let roomLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 10, weight: .medium)
		label.textColor = UIColor.htw.mediumGrey
		label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byCharWrapping
		return label
	}()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.htw.mediumGrey
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byCharWrapping
        return label
    }()


	// MARK: - Init

    override func initialSetup() {
        self.contentView.layer.cornerRadius = 4
        self.contentView.clipsToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = Const.shadowRadius
        self.layer.shadowOpacity = Const.shadowOpacity

        self.contentView.add(self.colorView,
                             self.titleLabel,
                             self.roomLabel,
                             self.typeLabel) { v in
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
		NSLayoutConstraint.activate([
            self.colorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.colorView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.colorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.colorView.widthAnchor.constraint(equalToConstant: 3),
            
			self.titleLabel.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor,
                                                     constant: Const.margin),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.margin),
			self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                      constant: -Const.margin),

			self.roomLabel.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor,
                                                    constant: Const.margin),
			self.roomLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
			self.roomLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                     constant: -Const.margin),
            
            self.typeLabel.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor,
                                                    constant: Const.margin),
            self.typeLabel.topAnchor.constraint(equalTo: self.roomLabel.bottomAnchor),
            self.typeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                     constant: -Const.margin),
            self.typeLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor,
                                                   constant: -Const.margin)
		])
    }

    func update(viewModel: LectureViewModel) {
        self.contentView.backgroundColor = UIColor(hex: viewModel.color).tendingTowards(.white, percentage: 0.9)
        self.colorView.backgroundColor = UIColor(hex: viewModel.color)
        self.titleLabel.text = viewModel.shortTitle
        self.roomLabel.text = viewModel.room
        self.typeLabel.text = viewModel.type
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

}

// MARK: - Highlightable
extension LectureCollectionViewCell: Highlightable {

    func highlight(animated: Bool) {
		guard isHighlightable else { return }
        let animations: () -> Void = {
            self.transform = CGAffineTransform.identity.scaledBy(x: Const.highlightedScale, y: Const.highlightedScale)
            self.layer.shadowRadius = Const.highlightedShadowRadius
            self.layer.shadowOpacity = Const.highlightedShadowOpacity
        }

        if !animated {
            animations()
        } else {
			let duration = 0.08

			let shadowRadiusAnimation = CABasicAnimation(keyPath: "shadowRadius")
			shadowRadiusAnimation.fromValue = Const.shadowRadius
			shadowRadiusAnimation.toValue = Const.highlightedShadowRadius
			shadowRadiusAnimation.duration = duration
			self.layer.add(shadowRadiusAnimation, forKey: "shadowRadiusAnimation")

			let shadowOpacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
			shadowOpacityAnimation.fromValue = Const.shadowOpacity
			shadowOpacityAnimation.toValue = Const.highlightedShadowOpacity
			shadowOpacityAnimation.duration = duration
			self.layer.add(shadowOpacityAnimation, forKey: "shadowOpacityAnimation")

			UIView.animate(withDuration: duration, animations: animations)
        }
    }

    func unhighlight(animated: Bool) {
		guard isHighlightable else { return }
        let animations: () -> Void = {
            self.transform = CGAffineTransform.identity
            self.layer.shadowRadius = Const.shadowRadius
            self.layer.shadowOpacity = Const.shadowOpacity
        }

        if !animated {
            animations()
        } else {
			let duration = 0.18

			let shadowRadiusAnimation = CABasicAnimation(keyPath: "shadowRadius")
			shadowRadiusAnimation.fromValue = Const.highlightedShadowRadius
			shadowRadiusAnimation.toValue = Const.shadowRadius
			shadowRadiusAnimation.duration = duration
			self.layer.add(shadowRadiusAnimation, forKey: "shadowRadiusAnimation")

			let shadowOpacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
			shadowOpacityAnimation.fromValue = Const.highlightedShadowOpacity
			shadowOpacityAnimation.toValue = Const.shadowOpacity
			shadowOpacityAnimation.duration = duration
			self.layer.add(shadowOpacityAnimation, forKey: "shadowOpacityAnimation")

			UIView.animate(withDuration: duration, animations: animations)
        }
    }

}
