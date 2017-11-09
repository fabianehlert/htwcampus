//
//  NoResultsView.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 09.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class NoResultsView: View {
	
	private lazy var imageView: UIImageView = {
		let i = UIImageView()
		i.contentMode = .scaleAspectFit
		i.translatesAutoresizingMaskIntoConstraints = false
		return i
	}()
	
	private lazy var label: UILabel = {
		let l = UILabel()
		l.font = .systemFont(ofSize: 30, weight: .medium)
		l.textColor = UIColor.htw.mediumGrey
		l.textAlignment = .center
		l.translatesAutoresizingMaskIntoConstraints = false
		return l
	}()
	
	// MARK: - Init
	
	init(frame: CGRect, message: String, image: UIImage?) {
		super.init(frame: frame)
		
		self.label.text = message
		self.imageView.image = image
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup
	
	func setMessage(_ message: String, image: UIImage?) {
		self.label.text = message
		self.imageView.image = image
	}
	
	override func initialSetup() {
		let stackView = UIStackView(arrangedSubviews: [self.imageView, self.label])
		stackView.alignment = .center
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.spacing = 10
		stackView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			stackView.topAnchor.constraint(equalTo: self.topAnchor),
			stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
	
}
