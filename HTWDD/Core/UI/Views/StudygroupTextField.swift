//
//  StudygroupTextField.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class StudygroupTextField: UITextField {

	enum ConfigurationType {
		case
		year,
		major,
		group

		var placeholder: String {
			switch self {
			case .year:
				return "--"
			case .major:
				return "---"
			case .group:
				return "--"
			}
		}

		/// Required amount of characters (digits).
		var length: Int {
			switch self {
			case .year:
				return 2
			case .major:
				return 3
			case .group:
				return 2
			}
		}

		/// Regex used for input validation.
		var regex: String {
			return "[0-9]{\(self.length)}"
		}
	}

	// MARK: - Properties

	var configurationType: ConfigurationType? {
		didSet {
			self.updateUI()
		}
	}

	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		self.setup()
	}

	// MARK: - Setup

	private func setup() {
		self.updateUI()
	}

	private func updateUI() {
		self.layer.cornerRadius = 4
		self.placeholder = self.configurationType?.placeholder
	}

	// MARK: - Validation

	/** Verifies that the input given consists of digits and digits only.
	
	**Note: Don't use for checking the final result!**
	
	*	Prevents e.g. pasting non-digit characters.
	*/
	func isInputValid(_ string: String) -> Bool {
		return Regex.evaluate(input: string, with: Regex.digits)
	}

	/** Verifies that the input given consists of digits and digits only as well as checking if the input matches the desired length.
	*/
	func isInputFinal() -> Bool {
		guard let config = self.configurationType else { return true }
		return Regex.evaluate(input: self.text ?? "", with: config.regex)
	}

}
