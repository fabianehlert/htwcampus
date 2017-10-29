//
//  OnboardUnixLoginViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardUnixLoginViewController: ViewController {

    private enum Const {
        static let minSNumberLength = 4
        static let maxSNumberLength = 6
    }

    var onFinish: ((GradeService.Auth?) -> Void)?

    private lazy var continueButton = ReactiveButton()

    private lazy var usernameTextField = TextField()
    private lazy var passwordTextField = TextField()

    override func initialSetup() {
        super.initialSetup()

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        // --- Title Label ---

        let titleLabel = UILabel()
        titleLabel.text = Loca.Onboarding.UnixLogin.title
        titleLabel.font = .systemFont(ofSize: 44, weight: .bold)
        titleLabel.textColor = UIColor.htw.textHeadline
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleContainer = UIView()
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(titleLabel)
        self.view.addSubview(titleContainer)

        // --- Description Label ---

        let descriptionLabel = UILabel()
        descriptionLabel.text = Loca.Onboarding.UnixLogin.body
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .medium)
        descriptionLabel.textColor = UIColor.htw.textBody
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        // --- Text fields ---

        let configureTextField: (UITextField) -> Void = {
            $0.font = .systemFont(ofSize: 30, weight: .medium)
            $0.backgroundColor = UIColor.htw.veryLightGrey
            $0.textAlignment = .center
            $0.delegate = self
            $0.addTarget(self, action: #selector(self.inputChanges(textField:)), for: .editingChanged)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [self.usernameTextField, self.passwordTextField]
            .forEach(configureTextField)
        self.usernameTextField.keyboardType = .numberPad
        self.usernameTextField.text = "s"
        self.passwordTextField.isSecureTextEntry = true

        let textFieldStackView = UIStackView(arrangedSubviews: [
            self.usernameTextField,
            self.passwordTextField
            ])
        textFieldStackView.axis = .vertical
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

        // --- Continue Button ---

        self.continueButton.isEnabled = false
        self.continueButton.setTitle(Loca.letsgo, for: .normal)
        self.continueButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        self.continueButton.backgroundColor = UIColor.htw.blue
        self.continueButton.layer.cornerRadius = 12
        self.continueButton.translatesAutoresizingMaskIntoConstraints = false
        self.continueButton.addTarget(self, action: #selector(continueBoarding), for: .touchUpInside)
        self.view.addSubview(self.continueButton)

        // --- Skip Button ---

        let skip = ReactiveButton()
        skip.setTitle(Loca.Onboarding.Studygroup.notnow, for: .normal)
        skip.setTitleColor(UIColor.htw.blue, for: .normal)
        skip.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        skip.translatesAutoresizingMaskIntoConstraints = false
        skip.addTarget(self, action: #selector(skipBoarding), for: .touchUpInside)
        titleContainer.addSubview(skip)

        // --- Constraints ---

        NSLayoutConstraint.activate([
            titleContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleContainer.bottomAnchor.constraint(equalTo: centerStackView.topAnchor),
            titleContainer.widthAnchor.constraint(equalTo: centerStackView.widthAnchor),

            skip.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            skip.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),

            centerStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            centerStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50),
            centerStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),

            textFieldStackView.heightAnchor.constraint(equalToConstant: 60 * 2 + 12),

            self.continueButton.heightAnchor.constraint(equalToConstant: 55),
            self.continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.continueButton.widthAnchor.constraint(equalTo: centerStackView.widthAnchor)
            ])

        var top = NSLayoutConstraint()
        var bottom = NSLayoutConstraint()
        if #available(iOS 11.0, *) {
            top = titleContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12)
            bottom = self.continueButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        } else {
            top = titleContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12)
            bottom = self.continueButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
        }
        NSLayoutConstraint.activate([top, bottom])

        self.usernameTextField.becomeFirstResponder()
    }

    // MARK: - Actions

    @objc private func continueBoarding() {
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

    @objc private func skipBoarding() {
        self.onFinish?(nil)
    }

}

extension OnboardUnixLoginViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string) as String

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

    @objc func inputChanges(textField: StudygroupTextField) {

        let sNumberCount = (self.usernameTextField.text?.count ?? 0) - 1
        let s = sNumberCount > Const.minSNumberLength && sNumberCount < Const.maxSNumberLength
        let p = (self.passwordTextField.text?.count ?? 0) > 0

        if s && p {
            self.continueButton.isEnabled = true
        } else {
            self.continueButton.isEnabled = false
        }
    }

}
