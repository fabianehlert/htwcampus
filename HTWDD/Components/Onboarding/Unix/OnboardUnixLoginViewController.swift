//
//  OnboardUnixLoginViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardUnixLoginViewController: OnboardDetailViewController<GradeService.Auth> {

    private enum Const {
        static let minSNumberLength = 4
        static let maxSNumberLength = 6
    }

	private lazy var usernameTextField: TextField = {
		let field = TextField()
		field.placeholder = Loca.Onboarding.UnixLogin.sPlaceholder
		return field
	}()
	private lazy var passwordTextField: PasswordField = {
		let field = PasswordField()
		field.placeholder = Loca.Onboarding.UnixLogin.passwordPlaceholder
		field.onOnePasswordClick = { [weak self] in
			guard let `self` = self else { return }
			OnePasswordExtension.shared().findLogin(forURLString: "https://www.htw-dresden.de",
													for: self,
													sender: nil) { data, error in
														guard let data = data else { return }
														self.usernameTextField.text = data[AppExtensionUsernameKey] as? String
														self.passwordTextField.text = data[AppExtensionPasswordKey] as? String
														self.checkState()
			}
		}
		return field
	}()

    override func initialSetup() {
        self.config = .init(title: Loca.Onboarding.UnixLogin.title,
                            description: Loca.Onboarding.UnixLogin.body,
                            contentViews: [self.usernameTextField, self.passwordTextField],
                            contentViewsStackViewAxis: NSLayoutConstraint.Axis.vertical,
                            notNowText: Loca.Onboarding.UnixLogin.notnow,
                            continueButtonText: Loca.letsgo)

        super.initialSetup()

        self.usernameTextField.text = "s"
        self.usernameTextField.keyboardType = .numberPad
    }

    // MARK: - Actions

    private var loading = false
    
    @objc
    override func continueBoarding() {
        guard !self.loading else { return }
        
        guard
            let sNumber = self.usernameTextField.text,
            let password = self.passwordTextField.text
        else {
            self.onFinish?(nil)
            return
        }

        self.loading = true
        let auth = GradeService.Auth(username: sNumber, password: password)
        GradeService.checkIfValid(auth: auth) { [weak self] success in
            self?.loading = false
            if success {
                self?.onFinish?(auth)
                return
            }
            
            let alert = UIAlertController(title: Loca.Grades.noResults.title, message: Loca.Grades.noResults.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Loca.ok, style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }

    override func shouldContinue() -> Bool {
        let sNumberCount = (self.usernameTextField.text?.count ?? 0) - 1
        let s = sNumberCount > Const.minSNumberLength && sNumberCount < Const.maxSNumberLength
        let p = (self.passwordTextField.text?.count ?? 0) > 0

        return s && p
    }

    override func shouldReplace(textField: UITextField, newString: String) -> Bool {
        switch textField {
        case self.usernameTextField:
            if newString.isEmpty {
                textField.text = "s"
                return false
            } else if newString.count > Const.maxSNumberLength {
                return false
            }
            if !newString.hasPrefix("s") {
                textField.text = "s" + newString
            }
        default: break
        }
        return true
    }
}
