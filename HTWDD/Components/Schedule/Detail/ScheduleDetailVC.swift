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
		static let margin: CGFloat = 15
	}
	
	private let viewModel: ScheduleDetailContentViewModel
	
	// MARK: - Views

	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 24, weight: .semibold)
		label.textColor = UIColor.htw.textHeadline
		label.numberOfLines = 2
		label.lineBreakMode = .byWordWrapping
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var professorLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .medium)
		label.textColor = UIColor.htw.textHeadline
		label.numberOfLines = 1
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var typeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = .white
		label.numberOfLines = 1
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var roomLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = .white
		label.numberOfLines = 1
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// MARK: - Init

    init(lecture: Lecture) {
        self.viewModel = ScheduleDetailContentViewModel(lecture: lecture)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	// MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	// MARK: - UI

	override func initialSetup() {
		self.nameLabel.text = self.viewModel.title
		self.professorLabel.text = self.viewModel.professor
		self.typeLabel.text = self.viewModel.type
		self.roomLabel.text = self.viewModel.rooms.first ?? "No room"

		self.view.addSubview(self.nameLabel)
		self.view.addSubview(self.professorLabel)
		
		// --
		
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				self.nameLabel.leadingAnchor.constraint(
					equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Const.margin),
				self.nameLabel.topAnchor.constraint(
					equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Const.margin),
				self.nameLabel.trailingAnchor.constraint(
					equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: Const.margin),
				
				self.professorLabel.leadingAnchor.constraint(
					equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Const.margin),
				self.professorLabel.topAnchor.constraint(
					equalTo: self.nameLabel.bottomAnchor),
				self.professorLabel.trailingAnchor.constraint(
					equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: Const.margin)
			])
		} else {
			
		}
		
		// --
		
		let typeContainer = UIView()
		typeContainer.backgroundColor = UIColor.htw.blue
		typeContainer.layer.cornerRadius = 6
		typeContainer.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(typeContainer)
		self.view.addSubview(self.typeLabel)

		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				typeContainer.leadingAnchor.constraint(
					equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Const.margin),
				typeContainer.topAnchor.constraint(
					equalTo: self.professorLabel.bottomAnchor, constant: 10),
				typeContainer.heightAnchor.constraint(
					equalTo: self.typeLabel.heightAnchor, constant: 10),
				typeContainer.widthAnchor.constraint(
					equalTo: self.typeLabel.widthAnchor, constant: 14)
			])
		} else {
			NSLayoutConstraint.activate([
				typeContainer.leadingAnchor.constraint(
					equalTo: self.view.leadingAnchor, constant: Const.margin),
				typeContainer.topAnchor.constraint(
					equalTo: self.professorLabel.bottomAnchor, constant: 10),
				typeContainer.heightAnchor.constraint(
					equalTo: self.typeLabel.heightAnchor, constant: 10),
				typeContainer.widthAnchor.constraint(
					equalTo: self.typeLabel.widthAnchor, constant: 14)
			])
		}
		
		NSLayoutConstraint.activate([
			self.typeLabel.centerXAnchor.constraint(equalTo: typeContainer.centerXAnchor),
			self.typeLabel.centerYAnchor.constraint(equalTo: typeContainer.centerYAnchor)
		])

		// --

		let roomContainer = UIView()
		roomContainer.backgroundColor = UIColor.htw.orange
		roomContainer.layer.cornerRadius = 6
		roomContainer.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(roomContainer)
		self.view.addSubview(self.roomLabel)
		
		NSLayoutConstraint.activate([
			roomContainer.leadingAnchor.constraint(
				equalTo: typeContainer.trailingAnchor, constant: 8),
			roomContainer.topAnchor.constraint(
				equalTo: self.professorLabel.bottomAnchor, constant: 10),
			roomContainer.heightAnchor.constraint(
				equalTo: self.roomLabel.heightAnchor, constant: 10),
			roomContainer.widthAnchor.constraint(
				equalTo: self.roomLabel.widthAnchor, constant: 14)
		])
		
		NSLayoutConstraint.activate([
			self.roomLabel.centerXAnchor.constraint(equalTo: roomContainer.centerXAnchor),
			self.roomLabel.centerYAnchor.constraint(equalTo: roomContainer.centerYAnchor)
		])
		
		// --
		
		let separator = UIView()
		separator.backgroundColor = UIColor.htw.veryLightGrey
		separator.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(separator)

		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				separator.leadingAnchor.constraint(
					equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Const.margin),
				separator.topAnchor.constraint(
					equalTo: typeContainer.bottomAnchor, constant: 10),
				separator.trailingAnchor.constraint(
					equalTo: self.view.trailingAnchor),
				separator.heightAnchor.constraint(
					equalToConstant: 2)
			])
		} else {
			NSLayoutConstraint.activate([
				separator.leadingAnchor.constraint(
					equalTo: self.view.leadingAnchor, constant: Const.margin),
				separator.topAnchor.constraint(
					equalTo: self.typeLabel.bottomAnchor, constant: Const.margin),
				separator.trailingAnchor.constraint(
					equalTo: self.view.trailingAnchor),
				separator.heightAnchor.constraint(
					equalToConstant: 2)
			])
		}
	}
	
	// MARK: - Actions
	
	@objc
	private func tapRecognized(_ sender: UIGestureRecognizer) {
		self.dismiss(animated: true)
	}
	
}
