//
//  IntroButton.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ReactiveButton: UIButton {
	var isHighlightable: Bool = true
	
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
extension ReactiveButton: Highlightable {

	enum Const {
		static let highlightedScale: CGFloat = 0.95

		static let normalAlpha: CGFloat = 1.0
		static let highlightedAlpha: CGFloat = 0.6
	}

	func highlight(animated: Bool) {
		let animations: () -> Void = {
			self.transform = CGAffineTransform.identity.scaledBy(x: Const.highlightedScale, y: Const.highlightedScale)
			self.alpha = Const.highlightedAlpha
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
			self.alpha = Const.normalAlpha
		}

		if !animated {
			animations()
		} else {
			let duration = 0.18
			UIView.animate(withDuration: duration, animations: animations)
		}
	}

}
