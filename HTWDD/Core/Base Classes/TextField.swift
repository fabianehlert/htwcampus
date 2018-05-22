//
//  TextField.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 19.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class TextField: UITextField {

	var insets: UIEdgeInsets = {
		return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
	}()
	
	// MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initialSetup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialSetup()
	}

	func initialSetup() {}

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 12
    }
    
	// MARK: - TextField
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, self.insets)
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, self.insets)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, self.insets)
	}
}

class PasswordField: TextField {
	
	var onOnePasswordClick: (() -> Void)?
	
	private var onePasswordButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(#imageLiteral(resourceName: "onepassword-button"), for: .normal)
		button.addTarget(self, action: #selector(find1PasswordLogin), for: .touchUpInside)
		return button
	}()
	
	override func initialSetup() {
		self.isSecureTextEntry = true
		
		if OnePasswordExtension.shared().isAppExtensionAvailable() {
			self.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 48)
			
			self.onePasswordButton.translatesAutoresizingMaskIntoConstraints = false
			self.add(self.onePasswordButton)
			
			NSLayoutConstraint.activate([
				self.onePasswordButton.heightAnchor.constraint(equalToConstant: 44),
				self.onePasswordButton.widthAnchor.constraint(equalToConstant: 44),
				self.onePasswordButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
				self.onePasswordButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
			])
		}
	}
	
	// MARK: - Actions
	
	@objc
	private func find1PasswordLogin() {
		self.onOnePasswordClick?()
	}
	
}
