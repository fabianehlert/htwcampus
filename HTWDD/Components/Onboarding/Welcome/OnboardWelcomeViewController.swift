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
    }

	override func initialSetup() {

		// --- Title label ---
		let titleLabel = UILabel()
		titleLabel.font = .systemFont(ofSize: 44, weight: .bold)
		titleLabel.textAlignment = .left
		titleLabel.numberOfLines = 2
		titleLabel.translatesAutoresizingMaskIntoConstraints = false

		let w = Loca.Onboarding.Welcome.Title
		let welcome = NSMutableAttributedString(string: w)
		welcome.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.htw.textHeadline, range: NSRange(location: 0, length: w.count))

		if let r = w.rangeOfSubString("HTW") {
			welcome.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.htw.orange, range: r)
		}

		titleLabel.attributedText = welcome

		let titleContainer = UIView()
		titleContainer.translatesAutoresizingMaskIntoConstraints = false
		titleContainer.add(titleLabel)
		self.view.add(titleContainer)

		// --- Description box ---

		let descriptions: [(String, String)] = [
			(Loca.Schedule.title, Loca.Onboarding.Welcome.ScheduleDescription),
			(Loca.Canteen.title, Loca.Onboarding.Welcome.CanteenDescription),
			(Loca.Grades.title, Loca.Onboarding.Welcome.GradesDescription)
		]
		let stackViews: [UIStackView] = descriptions.map { descPair in

			let title = UILabel()
			title.text = descPair.0
			title.font = .systemFont(ofSize: 20, weight: .semibold)
			title.textColor = UIColor.htw.textHeadline

			let desc = UILabel()
			desc.text = descPair.1
			desc.font = .systemFont(ofSize: 17, weight: .medium)
			desc.textColor = UIColor.htw.textBody
			desc.numberOfLines = 0

			let s = UIStackView(arrangedSubviews: [title, desc])
			s.axis = .vertical

			return s
		}

		let descriptionStackView = UIStackView(arrangedSubviews: stackViews)
		descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
		descriptionStackView.axis = .vertical
		descriptionStackView.distribution = .fillProportionally
		descriptionStackView.spacing = 20.0
		self.view.add(descriptionStackView)

		// --- Continue Button ---

		let continueButton = ReactiveButton()
		continueButton.setTitle(Loca.nextStep, for: .normal)
		continueButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
		continueButton.backgroundColor = UIColor.htw.blue
		continueButton.layer.cornerRadius = 12
		continueButton.translatesAutoresizingMaskIntoConstraints = false
		continueButton.addTarget(self, action: #selector(continueBoarding), for: .touchUpInside)
		self.view.add(continueButton)

		// --- Constraints ---

		NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: self.view.htw.safeAreaLayoutGuide.topAnchor, constant: 12),
			titleContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			titleContainer.bottomAnchor.constraint(equalTo: descriptionStackView.topAnchor),
			titleContainer.widthAnchor.constraint(equalTo: descriptionStackView.widthAnchor),

			titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
			titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),

			descriptionStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			descriptionStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
			descriptionStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),

			continueButton.heightAnchor.constraint(equalToConstant: 55),
			continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			continueButton.widthAnchor.constraint(equalTo: descriptionStackView.widthAnchor),
            continueButton.bottomAnchor.constraint(equalTo: self.view.htw.safeAreaLayoutGuide.bottomAnchor, constant: -20)
			])
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}
	
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

	// MARK: - Actions

	@objc private func continueBoarding() {
		self.onContinue?(self)
	}

}
