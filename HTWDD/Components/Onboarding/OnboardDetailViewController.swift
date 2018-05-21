//
//  OnboardDetailViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardDetailViewController<Product>: ViewController, UITextFieldDelegate, KeyboardPresentationHandler {

    var onFinish: ((Product?) -> Void)?

    struct Config {
        var title: String
        var description: String
        var contentViews: [UIView]
        var contentViewsStackViewAxis: UILayoutConstraintAxis
        var notNowText: String
        var continueButtonText: String
    }

    /// Set this config before calling super.initialSetup!
    var config: Config?

	private lazy var containerView = UIView()
	private lazy var titleContainer = UIView()
	private lazy var centerStackView = UIStackView()
    private lazy var continueButton = ReactiveButton()

	private lazy var topConstraint: NSLayoutConstraint = {
		return self.containerView.topAnchor.constraint(equalTo: self.view.htw.safeAreaLayoutGuide.topAnchor, constant: 0)
	}()
	private lazy var bottomConstraint: NSLayoutConstraint = {
		return self.containerView.bottomAnchor.constraint(equalTo: self.view.htw.safeAreaLayoutGuide.bottomAnchor, constant: 0)
	}()
	
	private lazy var titleTopConstraint: NSLayoutConstraint = {
		return self.titleContainer.topAnchor.constraint(equalTo: self.containerView.htw.safeAreaLayoutGuide.topAnchor, constant: 60)
	}()
	private lazy var continueButtonTopConstraint: NSLayoutConstraint = {
		return self.continueButton.topAnchor.constraint(equalTo: self.centerStackView.bottomAnchor, constant: 12)
	}()
	
    // MARK: - Overwrite functions

    @objc func continueBoarding() {
        preconditionFailure("Overwrite this method in your subclass!")
    }

    @objc func skipBoarding() {
        self.onFinish?(nil)
    }

    func shouldReplace(textField: UITextField, newString: String) -> Bool {
        return true
    }

    func shouldContinue() -> Bool {
        return false
    }
    
    func checkState() {
        self.continueButton.isEnabled = self.shouldContinue()
    }

    // MARK: - ViewController lifecycle

    override func initialSetup() {
        super.initialSetup()
		
        guard let config = self.config else {
            preconditionFailure("Tried to use OnboardDetailViewController without config. Abort!")
        }

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

		// --- Container ---
		
		self.containerView.translatesAutoresizingMaskIntoConstraints = false
		self.view.add(self.containerView)
		NSLayoutConstraint.activate([
			self.containerView.leadingAnchor.constraint(equalTo: self.view.htw.safeAreaLayoutGuide.leadingAnchor),
			self.topConstraint,
			self.containerView.trailingAnchor.constraint(equalTo: self.view.htw.safeAreaLayoutGuide.trailingAnchor),
			self.bottomConstraint
		])
		
        // --- Title Label ---

        let titleLabel = UILabel()
        titleLabel.text = config.title
        titleLabel.font = .systemFont(ofSize: 44, weight: .bold)
        titleLabel.textColor = UIColor.htw.textHeadline
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        self.titleContainer.translatesAutoresizingMaskIntoConstraints = false
        self.titleContainer.add(titleLabel)
        self.containerView.add(self.titleContainer)

        // --- Description Label ---

        let descriptionLabel = UILabel()
        descriptionLabel.text = config.description
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .medium)
        descriptionLabel.textColor = UIColor.htw.textBody
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        // --- Text fields ---

        let configureTextField: (UIView) -> Void = {
            guard let textField = $0 as? UITextField else {
                return
            }
            textField.font = .systemFont(ofSize: 30, weight: .medium)
            textField.backgroundColor = UIColor.htw.veryLightGrey
            textField.textAlignment = .left
            textField.delegate = self
            textField.addTarget(self, action: #selector(self.inputChanges(textField:)), for: .editingChanged)
            textField.translatesAutoresizingMaskIntoConstraints = false
        }

        config.contentViews
            .forEach(configureTextField)

        let textFieldStackView = UIStackView(arrangedSubviews: config.contentViews)
        textFieldStackView.axis = config.contentViewsStackViewAxis
        textFieldStackView.distribution = .fillEqually
        textFieldStackView.spacing = 12
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false

        self.centerStackView = UIStackView(arrangedSubviews: [
            descriptionLabel,
            textFieldStackView
		])
        self.centerStackView.axis = .vertical
        self.centerStackView.distribution = .fill
        self.centerStackView.spacing = 40
        self.centerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.add(self.centerStackView)

        // --- Continue Button ---

        self.continueButton.isEnabled = false
        self.continueButton.setTitle(config.continueButtonText, for: .normal)
        self.continueButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        self.continueButton.backgroundColor = UIColor.htw.blue
        self.continueButton.layer.cornerRadius = 12
        self.continueButton.translatesAutoresizingMaskIntoConstraints = false
        self.continueButton.rx
            .controlEvent(.touchUpInside)
            .subscribe({ [weak self] _ in self?.continueBoarding() })
            .disposed(by: self.rx_disposeBag)
        self.containerView.add(self.continueButton)

        // --- Skip Button ---

        let skip = ReactiveButton()
        skip.setTitle(config.notNowText, for: .normal)
        skip.setTitleColor(UIColor.htw.blue, for: .normal)
        skip.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        skip.translatesAutoresizingMaskIntoConstraints = false
        skip.rx
            .controlEvent(.touchUpInside)
            .subscribe({ [weak self] _ in self?.skipBoarding() })
            .disposed(by: self.rx_disposeBag)
        self.containerView.add(skip)

        // --- Constraints ---

        let stackViewHeight: CGFloat
        if config.contentViewsStackViewAxis == .horizontal {
            stackViewHeight = 60
        } else {
            stackViewHeight = 60.0 * CGFloat(config.contentViews.count) + textFieldStackView.spacing * (CGFloat(config.contentViews.count) - 1)
        }

        NSLayoutConstraint.activate([
            self.titleTopConstraint,
            self.titleContainer.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.titleContainer.widthAnchor.constraint(equalTo: self.centerStackView.widthAnchor),
			self.titleContainer.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 1),

			titleLabel.centerXAnchor.constraint(equalTo: self.titleContainer.centerXAnchor),
			titleLabel.centerYAnchor.constraint(equalTo: self.titleContainer.centerYAnchor),

			skip.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10),
			skip.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),

            self.centerStackView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
			self.centerStackView.topAnchor.constraint(equalTo: self.titleContainer.bottomAnchor, constant: 40),
            self.centerStackView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, multiplier: 0.8),

            textFieldStackView.heightAnchor.constraint(equalToConstant: stackViewHeight),

            self.continueButton.heightAnchor.constraint(equalToConstant: 55),
            self.continueButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.continueButton.widthAnchor.constraint(equalTo: self.centerStackView.widthAnchor),
            self.continueButton.bottomAnchor.constraint(equalTo: self.containerView.htw.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
		
		self.registerForKeyboardNotifications()
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    @objc func inputChanges(textField: TextField) {
        self.checkState()
    }

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string) as String

        return self.shouldReplace(textField: textField, newString: newString)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

	// MARK: - KeyboardPresentationHandler
	
	@objc
	func keyboardWillShow(_ notification: Notification) {
		self.animateWithKeyboardNotification(notification, layout: { frame in
			self.bottomConstraint.constant = -frame.height
			self.topConstraint.constant = -frame.height
			
			self.titleTopConstraint.isActive = false
			self.continueButtonTopConstraint.isActive = true
		}) {
			self.view.layoutIfNeeded()
		}
	}
	
	@objc
	func keyboardWillHide(_ notification: Notification) {
		self.animateWithKeyboardNotification(notification, layout: { frame in
			self.bottomConstraint.constant = 0
			self.topConstraint.constant = 0
			
			self.titleTopConstraint.isActive = true
			self.continueButtonTopConstraint.isActive = false
		}) {
			self.view.layoutIfNeeded()
		}
	}

}
