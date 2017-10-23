//
//  OnboardWelcomeViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardWelcomeViewController: ViewController {

	var onContinue: ((OnboardWelcomeViewController) -> Void)?

	// MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    private func setupUI() {

        let welcome = UILabel()
        if #available(iOS 11.0, *) {
            welcome.font = .preferredFont(forTextStyle: .largeTitle)
        } else {
            welcome.font = .preferredFont(forTextStyle: .headline)
        }
        welcome.translatesAutoresizingMaskIntoConstraints = false
        welcome.text = "Welcome!"
        let welcomeContainer = UIView()
        welcomeContainer.translatesAutoresizingMaskIntoConstraints = false
        welcomeContainer.addSubview(welcome)
        self.view.addSubview(welcomeContainer)

        let descriptions: [(String, String)] = [
            ("Schedule", "Your schedule shows you all your lectures."),
            ("Canteen", "See what is being served for lunch in the canteens around you."),
            ("Grades", "View what your professors graded you in your exams.")
        ]
        let stackViews: [UIStackView] = descriptions.map { descPair in
            let title = UILabel()
            title.text = descPair.0
            title.font = .preferredFont(forTextStyle: .headline)
            let desc = UILabel()
            desc.font = .preferredFont(forTextStyle: .body)
            desc.text = descPair.1
            desc.numberOfLines = 0
            let s = UIStackView(arrangedSubviews: [title, desc])
            s.axis = .vertical
            return s
        }
        let descriptionStackView = UIStackView(arrangedSubviews: stackViews)
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.axis = .vertical
        descriptionStackView.distribution = .fillProportionally
        descriptionStackView.spacing = 8.0
        self.view.addSubview(descriptionStackView)

        // TODO: UIColor.htw.blue vs UIColor(named: "htwBlue")

        let continueButton = IntroButton()
        continueButton.backgroundColor = UIColor.htw.blue
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.setTitle("Continue", for: .normal)
        continueButton.addTarget(self, action: #selector(continueBoarding), for: .touchUpInside)
        continueButton.layer.cornerRadius = 12
        self.view.addSubview(continueButton)

        NSLayoutConstraint.activate([

            welcome.centerXAnchor.constraint(equalTo: welcomeContainer.centerXAnchor),
            welcome.centerYAnchor.constraint(equalTo: welcomeContainer.centerYAnchor),

            welcomeContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            welcomeContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
            welcomeContainer.bottomAnchor.constraint(equalTo: descriptionStackView.topAnchor),

            descriptionStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            descriptionStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            descriptionStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),

            continueButton.heightAnchor.constraint(equalToConstant: 55),
            continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalTo: descriptionStackView.widthAnchor)

        ])

		var bottom = NSLayoutConstraint()
		if #available(iOS 11.0, *) {
			bottom = continueButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
		} else {
			bottom = continueButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
		}
		NSLayoutConstraint.activate([bottom])

    }

	// MARK: - Actions

	@objc private func continueBoarding() {
		self.onContinue?(self)
	}

}
