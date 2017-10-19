//
//  IntroButton.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class IntroButton: UIButton {
	override var isHighlighted: Bool {
		didSet {
			self.isHighlighted ? self.highlight(animated: true) : self.unhighlight(animated: true)
		}
	}

	override var isEnabled: Bool {
		didSet {
			self.alpha = self.isEnabled ? 1 : 0.3
		}
	}
}

// MARK: - Highlightable
extension IntroButton: Highlightable {

	enum Const {
		static let highlightedScale: CGFloat = 0.95
	}

	func highlight(animated: Bool) {
		let animations: () -> Void = {
			self.transform = CGAffineTransform.identity.scaledBy(x: Const.highlightedScale, y: Const.highlightedScale)
		}

		if !animated {
			animations()
		} else {
			let duration = 0.08
			UIView.animate(withDuration: duration, animations: animations)
		}
	}

	func unhighlight(animated: Bool) {
		let animations: () -> Void = {
			self.transform = CGAffineTransform.identity
		}

		if !animated {
			animations()
		} else {
			let duration = 0.18
			UIView.animate(withDuration: duration, animations: animations)
		}
	}

}
