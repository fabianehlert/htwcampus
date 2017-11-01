//
//  LectureListCell.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 01.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class LectureListCell: CollectionViewCell, Cell {

	enum Const {
		static let color = UIColor.white
		static let highlightedColor = UIColor.white

		static let textColor = UIColor.black

		static let highlightedScale: CGFloat = 0.97

		static let shadowRadius: CGFloat = 3
		static let highlightedShadowRadius: CGFloat = 1

		static let shadowOpacity: Float = 0.12
		static let highlightedShadowOpacity: Float = 0.3

		static let margin: CGFloat = 10
	}

	// MARK: - UI

	var widthConstraint = NSLayoutConstraint()

	let colorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(red: 0.76, green: 0.09, blue: 0.09, alpha: 1.0)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 2
		return view
	}()

	let typeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .medium)
		label.textColor = UIColor.htw.textBody
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20, weight: .medium)
		label.textColor = UIColor.htw.textHeadline
		label.textAlignment = .left
		label.numberOfLines = 2
		label.lineBreakMode = .byWordWrapping
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let roomLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .medium)
		label.textColor = UIColor.htw.textBody
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let timeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .medium)
		label.textColor = UIColor.htw.textBody
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// MARK: - Init

	override func initialSetup() {
		self.contentView.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.backgroundColor = .white
		self.contentView.layer.cornerRadius = 2
		self.contentView.clipsToBounds = true

		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOffset = .zero
		self.layer.shadowRadius = Const.shadowRadius
		self.layer.shadowOpacity = Const.shadowOpacity

		self.contentView.addSubview(self.colorView)
		self.contentView.addSubview(self.typeLabel)
		self.contentView.addSubview(self.titleLabel)
		self.contentView.addSubview(self.roomLabel)
		self.contentView.addSubview(self.timeLabel)

		self.widthConstraint = self.contentView.widthAnchor.constraint(equalToConstant: 351)

		NSLayoutConstraint.activate([
			self.widthConstraint,

			self.colorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.margin),
			self.colorView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.margin),
			self.colorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.margin),
			self.colorView.widthAnchor.constraint(equalToConstant: 5),

			self.typeLabel.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.margin),
			self.typeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.margin),
			self.typeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),

			self.titleLabel.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.margin),
			self.titleLabel.topAnchor.constraint(equalTo: self.typeLabel.bottomAnchor, constant: 2),
			self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),

			self.roomLabel.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.margin),
			self.roomLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 2),
			self.roomLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),

			self.timeLabel.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.margin),
			self.timeLabel.topAnchor.constraint(equalTo: self.roomLabel.bottomAnchor, constant: 2),
			self.timeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),
			self.timeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.margin)
		])
	}

	func update(viewModel: LectureViewModel) {
		self.typeLabel.text = viewModel.subtitle.uppercased()
		self.titleLabel.text = viewModel.title
		self.roomLabel.text = viewModel.room
		self.timeLabel.text = "\(viewModel.start) – \(viewModel.end)"
	}

	func updateWidth(_ width: CGFloat) {
		self.widthConstraint.constant = width
		layoutIfNeeded()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
	}

}

// MARK: - Highlightable
extension LectureListCell: Highlightable {

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
