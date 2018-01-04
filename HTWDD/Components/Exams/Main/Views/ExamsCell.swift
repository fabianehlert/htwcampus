//
//  ExamsCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 06.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

struct ExamsViewModel: ViewModel {
    let title: String
	let type: Exam.ExamType
	let branch: String
	let examiner: String
	let room: String
    
    let day: String
    let time: String
	
    init(model: Exam) {
        self.title = model.title
		self.type = model.type
        self.branch = model.branch == "" ? "-" : model.branch
		self.examiner = model.examiner
		
        self.day = model.day
        self.time = Loca.Exams.Cell.time(model.start, model.end)
        
		if model.rooms.isEmpty {
			self.room = Loca.Schedule.noRoom
		} else if model.rooms.count == 1 {
			self.room = model.rooms.first ?? Loca.Schedule.noRoom
		} else {
			self.room = model.rooms.joined(separator: ", ")
		}
    }
}

class ExamsCell: FlatCollectionViewCell, Cell {
    
    enum Const {
        static let margin: CGFloat = 12
		static let innerMargin: CGFloat = 5
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.htw.textHeadline
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.htw.textHeadline
        return label
    }()
	
	private let examinerLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
		label.textColor = UIColor.htw.mediumGrey
		return label
	}()

	private let branchLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
		label.textColor = UIColor.htw.mediumGrey
		return label
	}()
	
	private let typeBadge: BadgeLabel = {
		let badge = BadgeLabel()
		badge.textColor = UIColor.htw.textHeadline
		badge.backgroundColor = UIColor(hex: 0xE8E8E8)
		badge.font = .systemFont(ofSize: 13, weight: .semibold)
		return badge
	}()
	
	private let roomBadge: BadgeLabel = {
		let badge = BadgeLabel()
		badge.textColor = UIColor.htw.textHeadline
		badge.backgroundColor = UIColor(hex: 0xCFCFCF)
		badge.font = .systemFont(ofSize: 13, weight: .semibold)
		return badge
	}()
	
    override func initialSetup() {
        super.initialSetup()
        
        self.contentView.add(self.titleLabel,
                             self.timeLabel,
                             self.branchLabel,
                             self.examinerLabel,
                             self.typeBadge,
                             self.roomBadge) { v in
                                v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.margin),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.margin),
            
            self.timeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.margin),
            self.timeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),
            self.timeLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Const.innerMargin),
            
			self.branchLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.margin),
			self.branchLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),
			self.branchLabel.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 0),

			self.examinerLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.margin),
			self.examinerLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),
			self.examinerLabel.topAnchor.constraint(equalTo: self.branchLabel.bottomAnchor, constant: 0),
			
			self.typeBadge.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.margin),
			self.typeBadge.topAnchor.constraint(equalTo: self.examinerLabel.bottomAnchor, constant: Const.innerMargin),
			
			self.roomBadge.leadingAnchor.constraint(equalTo: self.typeBadge.trailingAnchor, constant: Const.innerMargin),
			self.roomBadge.topAnchor.constraint(equalTo: self.examinerLabel.bottomAnchor, constant: Const.innerMargin)
        ])
    }
    
    func update(viewModel: ExamsViewModel) {
        self.titleLabel.text = viewModel.title
		self.branchLabel.text = Loca.Exams.branch(viewModel.branch)
		self.examinerLabel.text = Loca.Exams.examiner(viewModel.examiner)
		self.typeBadge.text = viewModel.type.displayName
		self.roomBadge.text = viewModel.room
        
        let time = NSMutableAttributedString()
        time.append(NSAttributedString(string: viewModel.day,
                                       attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .bold)]))
        time.append(NSAttributedString(string: " "))
        time.append(NSAttributedString(string: viewModel.time,
                                       attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .medium)]))
        self.timeLabel.attributedText = time
    }
    
}
