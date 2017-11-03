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

	let colorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(red: 0.76, green: 0.09, blue: 0.09, alpha: 1.0)
		view.layer.cornerRadius = 3
		return view
	}()

	let typeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = UIColor.htw.mediumGrey
		label.textAlignment = .left
		return label
	}()

	let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .medium)
		label.textColor = UIColor.htw.textHeadline
		label.textAlignment = .left
		label.numberOfLines = 2
		label.lineBreakMode = .byWordWrapping
		return label
	}()

	let roomLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = UIColor.htw.textBody
		label.textAlignment = .left
		return label
	}()

	let timeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = UIColor.htw.blue
		label.textAlignment = .left
		return label
	}()

	// MARK: - Init

	override func initialSetup() {
        super.initialSetup()

		self.contentView.addSubview(self.colorView)
		self.contentView.addSubview(self.typeLabel)
		self.contentView.addSubview(self.titleLabel)
		self.contentView.addSubview(self.roomLabel)
		self.contentView.addSubview(self.timeLabel)
	}
    
    func updateLayout(width: CGFloat) {
        let innerMargin: CGFloat = 2
        
        self.colorView.frame = CGRect(x: Const.margin, y: Const.margin, width: 5, height: self.contentView.height - Const.margin*2)
        
        let labelsWidth = width - Const.margin * 3 - self.colorView.width
        func sizeForLabel(label: UILabel) -> CGSize {
            return label.sizeThatFits(CGSize(width: labelsWidth, height: CGFloat.greatestFiniteMagnitude))
        }
        
        self.typeLabel.frame = CGRect(origin: CGPoint(x: self.colorView.right + Const.margin, y: self.colorView.top),
                                      size: sizeForLabel(label: self.typeLabel))
        
        self.titleLabel.frame = CGRect(origin: CGPoint(x: self.typeLabel.left, y: self.typeLabel.bottom + innerMargin),
                                       size: sizeForLabel(label: self.titleLabel))
        
        self.roomLabel.frame = CGRect(origin: CGPoint(x: self.typeLabel.left, y: self.titleLabel.bottom + innerMargin),
                                      size: sizeForLabel(label: self.roomLabel))
        
        self.timeLabel.frame = CGRect(origin: CGPoint(x: self.typeLabel.left, y: self.roomLabel.bottom + innerMargin),
                                      size: sizeForLabel(label: self.timeLabel))
        
        self.colorView.frame = CGRect(x: Const.margin, y: Const.margin, width: 5, height: self.timeLabel.bottom - self.typeLabel.top)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateLayout(width: self.contentView.width)
    }
    
	func update(viewModel: LectureViewModel) {
		self.typeLabel.text = viewModel.subtitle.uppercased()
		self.titleLabel.text = viewModel.longTitle
		self.roomLabel.text = viewModel.room
		self.timeLabel.text = viewModel.timeString
	}
    
}

extension LectureListCell: HeightCalculator {
    
    static func height(for width: CGFloat, viewModel: LectureViewModel) -> CGFloat {
        let cell = LectureListCell()
        cell.update(viewModel: viewModel)
        cell.updateLayout(width: width)
        return cell.colorView.height + Const.margin*2
    }
    
}
