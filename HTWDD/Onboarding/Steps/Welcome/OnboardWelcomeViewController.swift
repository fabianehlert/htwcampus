//
//  OnboardWelcomeViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardWelcomeViewController: ViewController {

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

	@IBAction func continueBoarding() {
		let stg = OnboardStudygroupViewController()
		self.navigationController?.pushViewController(stg, animated: true)
	}

}
