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
		view.backgroundColor = UIColor(red: 0.76, green: 0.09, blue: 0.09, alpha: 1.0)
		view.layer.cornerRadius = 3
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

    let typeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xCFCFCF)
        view.layer.cornerRadius = 3
        return view
    }()
    
    let roomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xE8E8E8)
        view.layer.cornerRadius = 3
        return view
    }()

    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor.htw.textHeadline
        label.textAlignment = .center
        return label
    }()

	let roomLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .semibold)
		label.textColor = UIColor.htw.textHeadline
		label.textAlignment = .center
		return label
	}()

	// MARK: - Init

	override func initialSetup() {
        super.initialSetup()

        self.contentView.addSubview(self.beginLabel)
        self.contentView.addSubview(self.endLabel)
        self.contentView.addSubview(self.colorView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.professorLabel)
        self.contentView.addSubview(self.typeContainer)
        self.contentView.addSubview(self.roomContainer)
        self.contentView.addSubview(self.typeLabel)
        self.contentView.addSubview(self.roomLabel)
	}
    
    func updateLayout(width: CGFloat) {
        let innerMargin: CGFloat = 2
        let timeWidth: CGFloat = 48
        
        self.beginLabel.frame = CGRect(origin: CGPoint(x: Const.margin, y: Const.margin),
                                       size: CGSize(width: timeWidth, height: 21))
        self.endLabel.frame = CGRect(origin: CGPoint(x: Const.margin, y: self.height - 21 - Const.margin),
                                     size: CGSize(width: timeWidth, height: 21))
        
        self.colorView.frame = CGRect(x: self.beginLabel.right + Const.margin, y: Const.margin,
                                      width: 6, height: self.contentView.height - Const.margin*2)
        
        let labelsStart = Const.margin * 3 + self.beginLabel.width + self.colorView.width
        let labelsWidth = width - labelsStart - Const.margin
        func sizeForLabel(label: UILabel) -> CGSize {
            return label.sizeThatFits(CGSize(width: labelsWidth, height: CGFloat.greatestFiniteMagnitude))
        }
        
        self.titleLabel.frame = CGRect(origin: CGPoint(x: labelsStart, y: Const.margin),
                                       size: sizeForLabel(label: self.titleLabel))
        
        self.professorLabel.frame = CGRect(origin: CGPoint(x: labelsStart, y: self.titleLabel.bottom + innerMargin),
                                           size: sizeForLabel(label: self.professorLabel))
        
        self.typeLabel.frame = CGRect(origin: CGPoint(x: labelsStart, y: self.professorLabel.bottom + (innerMargin*3)),
                                      size: CGSize(width: self.typeLabel.intrinsicContentSize.width + (4*innerMargin), height: 19))
        
        self.roomLabel.frame = CGRect(origin: CGPoint(x: self.typeLabel.right + (innerMargin*3), y: self.professorLabel.bottom + (innerMargin*3)),
                                      size: CGSize(width: self.roomLabel.intrinsicContentSize.width + (4*innerMargin), height: 19))

        self.typeContainer.frame = CGRect(origin: CGPoint(x: self.typeLabel.left, y: self.typeLabel.top), size: self.typeLabel.frame.size)
        self.roomContainer.frame = CGRect(origin: CGPoint(x: self.roomLabel.left, y: self.roomLabel.top), size: self.roomLabel.frame.size)
        
        self.colorView.frame = CGRect(x: self.beginLabel.right + Const.margin, y: Const.margin,
                                      width: 6, height: (self.typeContainer.bottom - self.titleLabel.top) + 3)
    }
    
	func update(viewModel: LectureViewModel) {
        self.beginLabel.text = viewModel.begin
        self.endLabel.text = viewModel.end
		self.titleLabel.text = viewModel.longTitle
        self.professorLabel.text = viewModel.professor
        self.typeLabel.text = viewModel.subtitle
		self.roomLabel.text = viewModel.room
        
        self.roomContainer.alpha = viewModel.room != nil ? 1 : 0
        
        self.updateLayout(width: self.contentView.width)
	}
    
}

extension LectureListCell: HeightCalculator {
    func height(`for` width: CGFloat) -> CGFloat {
        self.updateLayout(width: width)
        return self.colorView.height + Const.margin*2
    }
}
