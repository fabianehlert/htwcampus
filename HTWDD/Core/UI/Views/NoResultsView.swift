//
//  NoResultsView.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 09.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class NoResultsView: View {
	
    private enum Const {
        static let horizontalMargin: CGFloat = 20
        static let minVerticalMaegin: CGFloat = 30
    }
    
	private lazy var imageView: UIImageView = {
		let i = UIImageView()
		i.contentMode = .scaleAspectFit
		i.translatesAutoresizingMaskIntoConstraints = false
		return i
	}()
	
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 26, weight: .semibold)
        l.textColor = .gray
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
	private let messageLabel: UILabel = {
		let l = UILabel()
		l.font = .systemFont(ofSize: 16, weight: .regular)
		l.textColor = .gray
		l.textAlignment = .center
        l.numberOfLines = 0
		l.translatesAutoresizingMaskIntoConstraints = false
		return l
	}()
	
	// MARK: - Init
	
    struct Configuration {
        let title: String
        let message: String
        let image: UIImage?
    }
    
    init(config: Configuration) {
		super.init(frame: .zero)
		
        self.titleLabel.text = config.title
		self.messageLabel.text = config.message
		self.imageView.image = config.image
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup
	
	func setMessage(_ message: String, image: UIImage?) {
		self.messageLabel.text = message
		self.imageView.image = image
	}
	
	override func initialSetup() {
		let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.imageView, self.messageLabel])
		stackView.alignment = .center
		stackView.axis = .vertical
		stackView.spacing = 10
		stackView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(stackView)
		
		NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Const.horizontalMargin),
			stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Const.horizontalMargin),
            stackView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, constant: -Const.minVerticalMaegin*2)
		])
	}
	
}
