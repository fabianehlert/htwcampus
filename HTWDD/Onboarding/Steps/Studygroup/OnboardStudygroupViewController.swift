//
//  OnboardStudygroupViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardStudygroupViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet private weak var continueButton: IntroButton? {
		didSet {
			self.continueButton?.layer.cornerRadius = 12
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
