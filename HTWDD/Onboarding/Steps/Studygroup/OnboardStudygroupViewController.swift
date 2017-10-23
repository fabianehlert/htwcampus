//
//  OnboardStudygroupViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardStudygroupViewController: UIViewController {

	var onContinue: ((OnboardStudygroupViewController, ScheduleDataSource.Auth?) -> Void)?
	var onSkip: ((OnboardStudygroupViewController) -> Void)?

	// MARK: - Outlets

	@IBOutlet private weak var continueButton: IntroButton? {
		didSet {
			self.continueButton?.layer.cornerRadius = 12
			self.continueButton?.isEnabled = false
		}
	}

	@IBOutlet private weak var yearTextField: StudygroupTextField?
	@IBOutlet private weak var majorTextField: StudygroupTextField?
	@IBOutlet private weak var groupTextField: StudygroupTextField?

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

		self.yearTextField?.configurationType = .year
		self.yearTextField?.delegate = self
		self.yearTextField?.addTarget(self, action: #selector(inputChanges(textField:)), for: .editingChanged)

		self.majorTextField?.configurationType = .major
		self.majorTextField?.delegate = self
		self.majorTextField?.addTarget(self, action: #selector(inputChanges(textField:)), for: .editingChanged)

		self.groupTextField?.configurationType = .group
		self.groupTextField?.delegate = self
		self.groupTextField?.addTarget(self, action: #selector(inputChanges(textField:)), for: .editingChanged)

		self.yearTextField?.becomeFirstResponder()
	}

	// MARK: - Actions

	@IBAction private func continueBoarding() {
		if let y = self.yearTextField?.text,
			let m = self.majorTextField?.text,
			let g = self.groupTextField?.text {

			let group = ScheduleDataSource.Auth(year: y, major: m, group: g)
			self.onContinue?(self, group)
		} else {
			self.onContinue?(self, nil)
		}
	}

	@IBAction private func skipBoarding() {
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

		if let y = yearTextField?.isInputFinal(),
			let m = majorTextField?.isInputFinal(),
			let g = groupTextField?.isInputFinal() {

			if y && m && g {
				self.continueButton?.isEnabled = true
			} else {
				self.continueButton?.isEnabled = false
			}
		}
	}

	///
	private func jumpToNextField(from textField: StudygroupTextField) {
		if textField == self.yearTextField {
			self.majorTextField?.becomeFirstResponder()
		} else if textField == self.majorTextField {
			self.groupTextField?.becomeFirstResponder()
		} else if textField == self.groupTextField {
			self.groupTextField?.resignFirstResponder()
		}
	}
}
