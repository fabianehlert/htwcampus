//
//  OnboardStudygroupViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardStudygroupViewController: ViewController {

	var onContinue: ((OnboardStudygroupViewController, ScheduleDataSource.Auth?) -> Void)?
	var onSkip: ((OnboardStudygroupViewController) -> Void)?

	private lazy var continueButton = ReactiveButton()

	private lazy var yearTextField = StudygroupTextField()
	private lazy var majorTextField = StudygroupTextField()
	private lazy var groupTextField = StudygroupTextField()

	// MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	// MARK: - UI

	private func setupUI() {
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

		// Create Caption Label

		let titleLabel = UILabel()
		titleLabel.text = "Study group"
		titleLabel.textColor = UIColor.htw.textHeadline

		if #available(iOS 11.0, *) {
			titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
		} else {
			titleLabel.font = .preferredFont(forTextStyle: .headline)
		}
		titleLabel.translatesAutoresizingMaskIntoConstraints = false

		let titleContainer = UIView()
		titleContainer.translatesAutoresizingMaskIntoConstraints = false
		titleContainer.addSubview(titleLabel)
		self.view.addSubview(titleContainer)

		// Description Label

		let descriptionLabel = UILabel()
		descriptionLabel.text = "In order to show you your personal schedule, we need to know what study group you're in."
		descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
		descriptionLabel.numberOfLines = 0
		descriptionLabel.textColor = UIColor.htw.textBody
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

		// Create text fields

		self.yearTextField.configurationType = .year
		self.yearTextField.font = .systemFont(ofSize: 30, weight: .medium)
		self.yearTextField.backgroundColor = UIColor.htw.veryLightGrey
		self.yearTextField.textAlignment = .center
		self.yearTextField.keyboardType = .numberPad
		self.yearTextField.delegate = self
		self.yearTextField.addTarget(self, action: #selector(inputChanges(textField:)), for: .editingChanged)
		self.yearTextField.translatesAutoresizingMaskIntoConstraints = false

		self.majorTextField.configurationType = .major
		self.majorTextField.font = .systemFont(ofSize: 30, weight: .medium)
		self.majorTextField.backgroundColor = UIColor.htw.veryLightGrey
		self.majorTextField.textAlignment = .center
		self.majorTextField.keyboardType = .numberPad
		self.majorTextField.delegate = self
		self.majorTextField.addTarget(self, action: #selector(inputChanges(textField:)), for: .editingChanged)
		self.majorTextField.translatesAutoresizingMaskIntoConstraints = false

		self.groupTextField.configurationType = .group
		self.groupTextField.font = .systemFont(ofSize: 30, weight: .medium)
		self.groupTextField.backgroundColor = UIColor.htw.veryLightGrey
		self.groupTextField.textAlignment = .center
		self.groupTextField.keyboardType = .numberPad
		self.groupTextField.delegate = self
		self.groupTextField.addTarget(self, action: #selector(inputChanges(textField:)), for: .editingChanged)
		self.groupTextField.translatesAutoresizingMaskIntoConstraints = false

		let textFieldStackView = UIStackView(arrangedSubviews: [
			self.yearTextField,
			self.majorTextField,
			self.groupTextField
		])
		textFieldStackView.axis = .horizontal
		textFieldStackView.distribution = .fillEqually
		textFieldStackView.spacing = 12
		textFieldStackView.translatesAutoresizingMaskIntoConstraints = false

		let centerStackView = UIStackView(arrangedSubviews: [
			descriptionLabel,
			textFieldStackView
		])
		centerStackView.axis = .vertical
		centerStackView.distribution = .fill
		centerStackView.spacing = 40
		centerStackView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(centerStackView)

		// Continue Button

		self.continueButton.isEnabled = false
		self.continueButton.setTitle("Let's go!", for: .normal)
		self.continueButton.backgroundColor = UIColor.htw.blue
		self.continueButton.layer.cornerRadius = 12
		self.continueButton.addTarget(self, action: #selector(continueBoarding), for: .touchUpInside)
		self.continueButton.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(self.continueButton)

		// Skip Button

		let skip = ReactiveButton()
		skip.setTitle("Not now", for: .normal)
		skip.setTitleColor(UIColor.htw.blue, for: .normal)
		skip.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
		skip.addTarget(self, action: #selector(skipBoarding), for: .touchUpInside)
		skip.translatesAutoresizingMaskIntoConstraints = false
		titleContainer.addSubview(skip)

		// Constraints

		NSLayoutConstraint.activate([
			titleContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			titleContainer.bottomAnchor.constraint(equalTo: centerStackView.topAnchor),
			titleContainer.widthAnchor.constraint(equalTo: centerStackView.widthAnchor),

			skip.topAnchor.constraint(equalTo: titleContainer.topAnchor),
			skip.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),

			titleLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
			titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),

			centerStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			centerStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
			centerStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),

			textFieldStackView.heightAnchor.constraint(equalToConstant: 60),

			self.continueButton.heightAnchor.constraint(equalToConstant: 55),
			self.continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.continueButton.widthAnchor.constraint(equalTo: centerStackView.widthAnchor)
		])

		var top = NSLayoutConstraint()
		var bottom = NSLayoutConstraint()
		if #available(iOS 11.0, *) {
			top = titleContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12)
			bottom = self.continueButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 12)
		} else {
			top = titleContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -20)
			bottom = self.continueButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
		}
		NSLayoutConstraint.activate([top, bottom])

		// TODO: continueButton has wrong y position
		
		// Make first text field active
		self.yearTextField.becomeFirstResponder()
	}

	// MARK: - Actions

	@objc private func continueBoarding() {
		if let y = self.yearTextField.text,
			let m = self.majorTextField.text,
			let g = self.groupTextField.text {

			let group = ScheduleDataSource.Auth(year: y, major: m, group: g)
			self.onContinue?(self, group)
		} else {
			self.onContinue?(self, nil)
		}
	}

	@objc private func skipBoarding() {
		self.onSkip?(self)
	}
}

// MARK: - UITextFieldDelegate
extension OnboardStudygroupViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		// TODO: overthink this design

		if let f = textField as? StudygroupTextField,
			let config = f.configurationType {

			let newString = (f.text ?? "") + string

			if newString.count > config.length {
				return false
			}

			return f.isInputValid(string)
		}

		return true
	}

	@objc func inputChanges(textField: StudygroupTextField) {
		if textField.isInputFinal() {
			self.jumpToNextField(from: textField)
		}

		let y = yearTextField.isInputFinal()
		let m = majorTextField.isInputFinal()
		let g = groupTextField.isInputFinal()

		if y && m && g {
			self.continueButton.isEnabled = true
		} else {
			self.continueButton.isEnabled = false
		}
	}

	///
	private func jumpToNextField(from textField: StudygroupTextField) {
		if textField == self.yearTextField {
			self.majorTextField.becomeFirstResponder()
		} else if textField == self.majorTextField {
			self.groupTextField.becomeFirstResponder()
		} else if textField == self.groupTextField {
			self.groupTextField.resignFirstResponder()
		}
	}
}
