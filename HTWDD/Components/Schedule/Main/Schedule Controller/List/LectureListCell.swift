//
//  LectureListCell.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 01.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class LectureListCell: FlatCollectionViewCell, Cell {

	enum Const {
		static let textColor = UIColor.black
		static let margin: CGFloat = 10
	}

	// MARK: - UI

	var widthConstraint = NSLayoutConstraint()

	let colorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(red: 0.76, green: 0.09, blue: 0.09, alpha: 1.0)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 3
		return view
	}()

	let typeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = UIColor.htw.mediumGrey
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .medium)
		label.textColor = UIColor.htw.textHeadline
		label.textAlignment = .left
		label.numberOfLines = 2
		label.lineBreakMode = .byWordWrapping
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let roomLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = UIColor.htw.textBody
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let timeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = UIColor.htw.blue
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// MARK: - Init

	override func initialSetup() {
        super.initialSetup()
        
		self.contentView.translatesAutoresizingMaskIntoConstraints = false

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
		self.titleLabel.text = viewModel.longTitle
		self.roomLabel.text = viewModel.room
		self.timeLabel.text = viewModel.timeString
	}

}
