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

    private lazy var usernameTextField = TextField()
    private lazy var passwordTextField = TextField()

    override func initialSetup() {
        self.config = .init(title: Loca.Onboarding.UnixLogin.title,
                            description: Loca.Onboarding.UnixLogin.body,
                            contentViews: [self.usernameTextField, self.passwordTextField],
                            contentViewsStackViewAxis: UILayoutConstraintAxis.vertical,
                            notNowText: Loca.Onboarding.UnixLogin.notnow,
                            continueButtonText: Loca.letsgo)

        super.initialSetup()

        self.usernameTextField.text = "s"
        self.usernameTextField.keyboardType = .numberPad
        self.passwordTextField.isSecureTextEntry = true
        self.usernameTextField.becomeFirstResponder()
    }

    // MARK: - Actions

    @objc
    override func continueBoarding() {
        guard
            let sNumber = self.usernameTextField.text,
            let password = self.passwordTextField.text
        else {
            self.onFinish?(nil)
            return
        }

        let auth = GradeService.Auth(username: sNumber, password: password)
        self.onFinish?(auth)
    }

    override func shouldContinue(textField: UITextField) -> Bool {
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
