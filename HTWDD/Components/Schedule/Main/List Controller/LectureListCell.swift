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
		static let margin: CGFloat = 8
	}

	// MARK: - UI

    let beginLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.htw.textHeadline
        label.textAlignment = .right
        return label
    }()

    let endLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.htw.textHeadline
        label.textAlignment = .right
        return label
    }()

	let colorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.htw.orange
		view.layer.cornerRadius = 2
		return view
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
    
    let professorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.htw.mediumGrey
        label.textAlignment = .left
        return label
    }()

    let typeLabel: BadgeLabel = {
        let label = BadgeLabel()
		label.backgroundColor = UIColor(hex: 0xE8E8E8)
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor.htw.textHeadline
        return label
    }()

	let roomLabel: BadgeLabel = {
		let label = BadgeLabel()
		label.backgroundColor = UIColor(hex: 0xCFCFCF)
		label.font = .systemFont(ofSize: 13, weight: .semibold)
		label.textColor = UIColor.htw.textHeadline
		return label
	}()

	// MARK: - Init

	override func initialSetup() {
        super.initialSetup()
        
        self.contentView.add(self.beginLabel,
                             self.endLabel,
                             self.colorView,
                             self.titleLabel,
                             self.professorLabel,
                             self.typeLabel,
                             self.roomLabel)
	}
    
    func updateLayout(width: CGFloat) {
        let innerMargin: CGFloat = 2
        let timeWidth: CGFloat = 48
        
        self.beginLabel.frame = CGRect(origin: CGPoint(x: Const.margin, y: Const.margin),
                                       size: CGSize(width: timeWidth, height: 21))
        self.endLabel.frame = CGRect(origin: CGPoint(x: Const.margin, y: self.height - 21 - Const.margin),
                                     size: CGSize(width: timeWidth, height: 21))
        
        self.colorView.frame = CGRect(x: self.beginLabel.right + Const.margin, y: Const.margin,
                                      width: 4, height: self.contentView.height - Const.margin*2)
        
        let labelsStart = Const.margin * 3 + self.beginLabel.width + self.colorView.width
        let labelsWidth = width - labelsStart - Const.margin
        func sizeForLabel(label: UILabel) -> CGSize {
            let height = label.sizeThatFits(CGSize(width: labelsWidth, height: CGFloat.greatestFiniteMagnitude)).height
            return CGSize(width: labelsWidth, height: height)
        }
        
        self.titleLabel.frame = CGRect(origin: CGPoint(x: labelsStart, y: Const.margin),
                                       size: sizeForLabel(label: self.titleLabel))
        
        self.professorLabel.frame = CGRect(origin: CGPoint(x: labelsStart, y: self.titleLabel.bottom + innerMargin),
                                           size: sizeForLabel(label: self.professorLabel))
        
		self.updateBadges(innerMargin: innerMargin, labelsStart: labelsStart)
		
        self.colorView.frame = CGRect(x: self.beginLabel.right + Const.margin, y: Const.margin,
                                      width: 4, height: (self.typeLabel.bottom - self.titleLabel.top) + 3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateLayout(width: self.contentView.width)
    }
    
	func update(viewModel: LectureViewModel) {
		self.colorView.backgroundColor = UIColor(hex: viewModel.color)
		
        self.beginLabel.text = viewModel.begin
        self.endLabel.text = viewModel.end
		self.titleLabel.text = viewModel.longTitle
        self.professorLabel.text = viewModel.professor
        self.typeLabel.text = viewModel.type
		self.roomLabel.text = viewModel.room
		
        self.roomLabel.alpha = viewModel.room != nil ? 1 : 0
		
		let innerMargin: CGFloat = 2
		let labelsStart = Const.margin * 3 + self.beginLabel.width + self.colorView.width
		self.updateBadges(innerMargin: innerMargin, labelsStart: labelsStart)
	}
	
	private func updateBadges(innerMargin: CGFloat, labelsStart: CGFloat) {
		self.typeLabel.frame = CGRect(origin: CGPoint(x: labelsStart, y: self.professorLabel.bottom + (innerMargin*3)),
									  size: CGSize(width: self.typeLabel.intrinsicContentSize.width, height: 19))
		
		let roomWidth = min(self.contentView.width - labelsStart - Const.margin - self.typeLabel.width - (innerMargin*3), self.roomLabel.intrinsicContentSize.width)
		self.roomLabel.frame = CGRect(origin: CGPoint(x: self.typeLabel.right + (innerMargin*3), y: self.professorLabel.bottom + (innerMargin*3)),
									  size: CGSize(width: roomWidth, height: 19))
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
