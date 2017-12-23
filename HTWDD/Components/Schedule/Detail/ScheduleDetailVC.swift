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
		static let margin: CGFloat = 30
		static let spacing: CGFloat = 15
		static let separator: CGFloat = 2
	}
	
	private let viewModel: LectureViewModel
	
    var onStatusChange: (() -> Void)?
    
	// MARK: - Views

	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.alwaysBounceVertical = true
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()
	
    let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.htw.orange
        view.layer.cornerRadius = 2
        return view
    }()

	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 30, weight: .bold)
		label.textColor = UIColor.htw.textHeadline
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.textAlignment = .left
		return label
	}()

	private lazy var professorLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .medium)
		label.textColor = UIColor.htw.mediumGrey
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.textAlignment = .left
		return label
	}()
		
	private lazy var typeLabel: BadgeLabel = {
		let label = BadgeLabel()
		label.font = .systemFont(ofSize: 18, weight: .semibold)
		label.textColor = UIColor.htw.textHeadline
		label.backgroundColor = UIColor(hex: 0xE8E8E8)
		return label
	}()

	private lazy var roomLabel: BadgeLabel = {
		let label = BadgeLabel()
		label.font = .systemFont(ofSize: 18, weight: .semibold)
		label.textColor = UIColor.htw.textHeadline
		label.backgroundColor = UIColor(hex: 0xCFCFCF)
		return label
	}()
	
	private lazy var timeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 22, weight: .semibold)
		label.textColor = UIColor.htw.textHeadline
		label.numberOfLines = 1
		label.textAlignment = .left
		return label
	}()

    private lazy var hideButton: ReactiveButton = {
        let button = ReactiveButton()
        button.setTitleColor(UIColor.htw.blue, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
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
		
		self.setupUI()
		self.update(viewModel: self.viewModel)
    }

	override func initialSetup() {
		super.initialSetup()
		
		if UIDevice.current.userInterfaceIdiom == .pad {
			self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Loca.close,
																	style: .done,
																	target: self,
																	action: #selector(dismissOrPopViewController))
		}
		
		if #available(iOS 11.0, *) {
			self.navigationItem.largeTitleDisplayMode = .never
		}
	}

	// MARK: - UI
	
	private func setupUI() {
        // ScrollView
		self.view.addSubview(self.scrollView)
		
		let layoutGuide = self.view.htw.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			self.scrollView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
			self.scrollView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
			self.scrollView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
			self.scrollView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
		])
		
        // Other views
        let separator = UIView()
        separator.backgroundColor = UIColor.htw.lightGrey

        let bottomSeparator = UIView()
        bottomSeparator.backgroundColor = UIColor.htw.lightGrey

        [self.colorView, self.timeLabel, self.nameLabel, self.professorLabel, self.typeLabel, self.roomLabel, self.hideButton, separator, bottomSeparator].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview($0)
        })
        
        self.hideButton.addTarget(self, action: #selector(hideLecture), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			self.nameLabel.leadingAnchor.constraint(
				equalTo: self.scrollView.leadingAnchor, constant: Const.margin),
			self.nameLabel.topAnchor.constraint(
				equalTo: self.scrollView.topAnchor, constant: Const.margin),
			self.nameLabel.trailingAnchor.constraint(
				equalTo: self.scrollView.trailingAnchor, constant: -Const.margin),
			self.nameLabel.widthAnchor.constraint(
				equalTo: self.scrollView.widthAnchor, multiplier: 1, constant: -(2*Const.margin)),
			
			self.professorLabel.leadingAnchor.constraint(
				equalTo: self.scrollView.leadingAnchor, constant: Const.margin),
			self.professorLabel.topAnchor.constraint(
				equalTo: self.nameLabel.bottomAnchor, constant: 4),
			self.professorLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -Const.margin),
            
            separator.leadingAnchor.constraint(
                equalTo: self.scrollView.leadingAnchor, constant: Const.margin),
            separator.topAnchor.constraint(
                equalTo: self.professorLabel.bottomAnchor, constant: Const.spacing),
            separator.trailingAnchor.constraint(
                equalTo: self.scrollView.trailingAnchor),
            separator.heightAnchor.constraint(
                equalToConstant: Const.separator),

            self.timeLabel.leadingAnchor.constraint(
                equalTo: self.colorView.trailingAnchor, constant: 10),
            self.timeLabel.topAnchor.constraint(
                equalTo: separator.bottomAnchor, constant: Const.spacing),
            
            self.typeLabel.leadingAnchor.constraint(
                equalTo: self.colorView.trailingAnchor, constant: 10),
            self.typeLabel.topAnchor.constraint(
                equalTo: self.timeLabel.bottomAnchor, constant: 8),
            self.roomLabel.leadingAnchor.constraint(
                equalTo: self.typeLabel.trailingAnchor, constant: 8),
            self.roomLabel.topAnchor.constraint(
                equalTo: self.timeLabel.bottomAnchor, constant: 8),

            bottomSeparator.leadingAnchor.constraint(
                equalTo: self.scrollView.leadingAnchor, constant: Const.margin),
            bottomSeparator.topAnchor.constraint(
                equalTo: self.colorView.bottomAnchor, constant: Const.spacing),
            bottomSeparator.trailingAnchor.constraint(
                equalTo: self.scrollView.trailingAnchor),
            bottomSeparator.heightAnchor.constraint(
                equalToConstant: Const.separator),
            bottomSeparator.bottomAnchor.constraint(
                equalTo: self.hideButton.topAnchor, constant: -Const.margin),

            self.colorView.leadingAnchor.constraint(
                equalTo: separator.leadingAnchor, constant: 8),
            self.colorView.topAnchor.constraint(
                equalTo: separator.bottomAnchor, constant: Const.spacing),
            self.colorView.bottomAnchor.constraint(
                equalTo: self.typeLabel.bottomAnchor, constant: 5),
            self.colorView.widthAnchor.constraint(equalToConstant: 4),
            
            self.hideButton.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,
                                                     constant: Const.margin),
            self.hideButton.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor,
                                                      constant: -Const.margin),
            self.hideButton.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor,
                                                    constant: -Const.margin),
            self.hideButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}

    func update(viewModel: LectureViewModel) {
        self.title = viewModel.shortTitle
        
        self.timeLabel.text = viewModel.time
        self.colorView.backgroundColor = UIColor(hex: viewModel.color)
        
        self.nameLabel.text = viewModel.longTitle
        self.professorLabel.text = viewModel.professor
        self.typeLabel.text = viewModel.rawType
        self.roomLabel.text = viewModel.room
        
        self.hideButton.setTitle(viewModel.hidden ? Loca.Schedule.Settings.Hide.otherAction : Loca.Schedule.Settings.Hide.action,
                                 for: .normal)
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	// MARK: - Actions
	
	@objc
	private func tapRecognized(_ sender: UIGestureRecognizer) {
		self.dismiss(animated: true)
	}
    
    @objc
    private func hideLecture() {
        self.onStatusChange?()
    }
	
}
