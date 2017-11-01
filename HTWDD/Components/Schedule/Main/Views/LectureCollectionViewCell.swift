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
        static let color = UIColor.white
        static let highlightedColor = UIColor.white

        static let textColor = UIColor.black

        static let highlightedScale: CGFloat = 0.97

        static let shadowRadius: CGFloat = 3
        static let highlightedShadowRadius: CGFloat = 1

        static let shadowOpacity: Float = 0.12
        static let highlightedShadowOpacity: Float = 0.3
    }

	// MARK: - UI

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.htw.textHeadline
		label.textAlignment = .left
		label.numberOfLines = 2
		label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
		label.textColor = UIColor.htw.textBody
		label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

	let roomLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 15, weight: .medium)
		label.textColor = UIColor.htw.textBody
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// MARK: - Init

    override func initialSetup() {
		self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 2
        self.contentView.clipsToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = Const.shadowRadius
        self.layer.shadowOpacity = Const.shadowOpacity

		self.contentView.addSubview(self.titleLabel)
		self.contentView.addSubview(self.subtitleLabel)

		let margin: CGFloat = 8
		NSLayoutConstraint.activate([
			self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
			self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
			self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),

			self.subtitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
			self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 2),
			self.subtitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin)
		])
    }

    func update(viewModel: LectureViewModel) {
        self.titleLabel.text = viewModel.title

		if let room = viewModel.room {
			self.subtitleLabel.text = "\(viewModel.subtitle) • \(room)"
		} else {
			self.subtitleLabel.text = viewModel.subtitle
		}
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

}

// MARK: - Highlightable
extension LectureCollectionViewCell: Highlightable {

    func highlight(animated: Bool) {
        let animations: () -> Void = {
            self.contentView.backgroundColor = Const.highlightedColor
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
        let animations: () -> Void = {
            self.contentView.backgroundColor = Const.color
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
