//
//  OnboardWelcomeViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

protocol OnboardWelcomeViewControllerDelegate: class {
	func didTapContinue(_ vc: OnboardWelcomeViewController)
}

class OnboardWelcomeViewController: ViewController {

	weak var delegate: OnboardWelcomeViewControllerDelegate?

	// MARK: - Outlets

	@IBOutlet private weak var continueButton: IntroButton? {
		didSet {
			self.continueButton?.layer.cornerRadius = 12
		}
	}

	// MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	// MARK: - Actions

	@IBAction private func continueBoarding() {
		self.delegate?.didTapContinue(self)
	}

}
