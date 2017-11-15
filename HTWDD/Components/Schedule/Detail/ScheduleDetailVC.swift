//
//  ScheduleDetailVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ScheduleDetailVC: ViewController {

	enum Const {
		static let margin: CGFloat = 20
		static let separator: CGFloat = 2
	}
	
	private let viewModel: LectureViewModel
	
	// MARK: - Views

	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 30, weight: .bold)
		label.textColor = UIColor.htw.textHeadline
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var professorLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .medium)
		label.textColor = UIColor.htw.mediumGrey
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let colorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.htw.orange
		view.layer.cornerRadius = 2
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var typeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .semibold)
		label.textColor = UIColor.htw.textHeadline
		label.numberOfLines = 1
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var roomLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .semibold)
		label.textColor = UIColor.htw.textHeadline
		label.numberOfLines = 1
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var timeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 22, weight: .semibold)
		label.textColor = UIColor.htw.textHeadline
		label.numberOfLines = 1
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// MARK: - Init

    init(lecture: AppLecture) {
        self.viewModel = LectureViewModel(model: lecture)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	// MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Loca.close, style: .done, target: self, action: #selector(dismissOrPopViewController))
        }
        
		self.colorView.backgroundColor = UIColor(hex: self.viewModel.color)
		
		self.nameLabel.text = self.viewModel.longTitle
		self.professorLabel.text = self.viewModel.professor
		self.typeLabel.text = self.viewModel.type
		self.roomLabel.text = self.viewModel.room

		self.view.addSubview(self.nameLabel)
		self.view.addSubview(self.professorLabel)

		// --
        
        let layoutGuide = self.view.htw.safeAreaLayoutGuide
		
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(
                equalTo: layoutGuide.leadingAnchor, constant: Const.margin),
            self.nameLabel.topAnchor.constraint(
                equalTo: self.topLayoutGuide.bottomAnchor, constant: Const.margin),
            self.nameLabel.trailingAnchor.constraint(
                equalTo: layoutGuide.trailingAnchor, constant: -Const.margin),
            
            self.professorLabel.leadingAnchor.constraint(
                equalTo: layoutGuide.leadingAnchor, constant: Const.margin),
            self.professorLabel.topAnchor.constraint(
                equalTo: self.nameLabel.bottomAnchor, constant: 4),
            self.professorLabel.trailingAnchor.constraint(
                equalTo: layoutGuide.trailingAnchor, constant: -Const.margin)
        ])
		
		// --
		
		let separator = UIView()
		separator.backgroundColor = UIColor.htw.lightGrey
		separator.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(separator)
		
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(
                equalTo: layoutGuide.leadingAnchor, constant: Const.margin),
            separator.topAnchor.constraint(
                equalTo: professorLabel.bottomAnchor, constant: 15),
            separator.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor),
            separator.heightAnchor.constraint(
                equalToConstant: Const.separator)
            ])
		
		// --
		
		self.timeLabel.text = self.viewModel.time
		
		self.view.addSubview(self.colorView)
		self.view.addSubview(self.timeLabel)
		
		NSLayoutConstraint.activate([
			self.timeLabel.leadingAnchor.constraint(equalTo: self.colorView.leadingAnchor, constant: 15),
			self.timeLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15),
		])
		
		// --
		
		let typeContainer = UIView()
		typeContainer.backgroundColor = UIColor(hex: 0xE8E8E8)
		typeContainer.layer.cornerRadius = 6
		typeContainer.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(typeContainer)
		self.view.addSubview(self.typeLabel)

		NSLayoutConstraint.activate([
			typeContainer.leadingAnchor.constraint(
				equalTo: self.colorView.leadingAnchor, constant: 15),
			typeContainer.topAnchor.constraint(
				equalTo: self.timeLabel.bottomAnchor, constant: 10),
			typeContainer.heightAnchor.constraint(
				equalTo: self.typeLabel.heightAnchor, constant: 10),
			typeContainer.widthAnchor.constraint(
				equalTo: self.typeLabel.widthAnchor, constant: 16)
			])
		
		NSLayoutConstraint.activate([
			self.typeLabel.centerXAnchor.constraint(equalTo: typeContainer.centerXAnchor),
			self.typeLabel.centerYAnchor.constraint(equalTo: typeContainer.centerYAnchor)
		])

		// --

		let roomContainer = UIView()
		roomContainer.backgroundColor = UIColor(hex: 0xCFCFCF)
		roomContainer.layer.cornerRadius = 6
		roomContainer.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(roomContainer)
		self.view.addSubview(self.roomLabel)
		
		NSLayoutConstraint.activate([
			roomContainer.leadingAnchor.constraint(
				equalTo: typeContainer.trailingAnchor, constant: 8),
			roomContainer.topAnchor.constraint(
				equalTo: self.timeLabel.bottomAnchor, constant: 10),
			roomContainer.heightAnchor.constraint(
				equalTo: self.roomLabel.heightAnchor, constant: 10),
			roomContainer.widthAnchor.constraint(
				equalTo: self.roomLabel.widthAnchor, constant: 16)
		])
		
		NSLayoutConstraint.activate([
			self.roomLabel.centerXAnchor.constraint(equalTo: roomContainer.centerXAnchor),
			self.roomLabel.centerYAnchor.constraint(equalTo: roomContainer.centerYAnchor)
		])
		
		// --
		
		let bottomSeparator = UIView()
		bottomSeparator.backgroundColor = UIColor.htw.lightGrey
		bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(bottomSeparator)
		
        NSLayoutConstraint.activate([
            bottomSeparator.leadingAnchor.constraint(
                equalTo: self.view.htw.safeAreaLayoutGuide.leadingAnchor, constant: Const.margin),
            bottomSeparator.topAnchor.constraint(
                equalTo: typeContainer.bottomAnchor, constant: 20),
            bottomSeparator.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor),
            bottomSeparator.heightAnchor.constraint(
                equalToConstant: Const.separator)
        ])
		
        NSLayoutConstraint.activate([
            self.colorView.leadingAnchor.constraint(equalTo: self.view.htw.safeAreaLayoutGuide.leadingAnchor, constant: Const.margin + 10),
            self.colorView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15),
            self.colorView.bottomAnchor.constraint(equalTo: bottomSeparator.topAnchor, constant: -15),
            self.colorView.widthAnchor.constraint(equalToConstant: 4)
        ])
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	// MARK: - Actions
	
	@objc
	private func tapRecognized(_ sender: UIGestureRecognizer) {
		self.dismiss(animated: true)
	}
	
}
