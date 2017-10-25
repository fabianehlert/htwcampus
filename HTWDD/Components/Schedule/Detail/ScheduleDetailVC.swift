//
//  ScheduleDetailVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ScheduleDetailVC: ViewController {

	// MARK: - Views

    private let viewModel: ScheduleDetailContentViewModel
    private let label = UILabel()

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
		self.label.text = self.viewModel.title
		self.label.font = UIFont.preferredFont(forTextStyle: .headline)
		self.label.numberOfLines = 0
		self.label.textAlignment = .center
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(label)

		NSLayoutConstraint.activate([
			self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
		])
	}

	// MARK: - Actions

    @objc
    private func tapRecognized(_ sender: UIGestureRecognizer) {
        self.dismiss(animated: true)
    }

}
