//
//  KeyboardPresentationHandler.swift
//  HTWDD
//
//  Shamelessly copied from Florian Schliep (https://twitter.com/floschliep)
//  Copyright © Florian Schliep
//

import UIKit

@objc
protocol KeyboardPresentationHandler {
	@objc
	func keyboardWillShow(_ notification: Notification)
	@objc
	func keyboardWillHide(_ notification: Notification)
}

extension KeyboardPresentationHandler {
	func registerForKeyboardNotifications() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardWillShow(_:)),
											   name: UIResponder.keyboardWillShowNotification,
											   object: nil)
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardWillHide(_:)),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)
	}
	
	func handleKeyboardNotification(_ notification: Notification, handler: (TimeInterval, UIView.AnimationCurve, CGRect) -> Void) {
		guard
			let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
			let curveValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
			let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
			else {
				return
		}
		// the animation curve may be undocumented
		var animationCurve = UIView.AnimationCurve.easeOut
		NSNumber(value: curveValue).getValue(&animationCurve)
		
		handler(duration, animationCurve, frame)
	}
	
	func animateWithKeyboardNotification(_ notification: Notification, layout: ((CGRect) -> Void)? = nil, animations: @escaping () -> Void) {
		self.handleKeyboardNotification(notification) { duration, curve, rect in
			layout?(rect)
			UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
				UIView.setAnimationCurve(curve)
				animations()
			}, completion: nil)
		}
	}
}
