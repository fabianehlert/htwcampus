//
//  MealCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

struct MealViewModel: ViewModel {
    let title: String
    let mensa: String
    let price: String?
    let counter: String?
    
    let detailUrl: URL
    let imageUrl: URL?
    
    init(model: Meal) {
        self.title = model.title
        self.mensa = model.canteen
        self.price = model.studentPrice?.htw.currencyString
        self.counter = model.counter
        self.detailUrl = model.url
        self.imageUrl = model.imageURL
    }
}

class MealCell: FlatCollectionViewCell, Cell {

    enum Const {
		static let imageWidth: CGFloat = 100
		static let priceMinWidth: CGFloat = 50
		static let innerItemMargin: CGFloat = 10
    }
	
    private lazy var imageView = UIImageView()
    private lazy var counterView = BadgeLabel()
	private lazy var priceView = BadgeLabel()
    private lazy var titleView = UILabel()

    override func initialSetup() {
        super.initialSetup()
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true

		self.counterView.font = .systemFont(ofSize: 13, weight: .semibold)
		self.counterView.textColor = UIColor.htw.textHeadline
		self.counterView.backgroundColor = UIColor(hex: 0xE8E8E8)

		self.priceView.font = .systemFont(ofSize: 13, weight: .semibold)
		self.priceView.textColor = UIColor.htw.textHeadline
		self.priceView.backgroundColor = UIColor(hex: 0xCFCFCF)

		self.titleView.font = .systemFont(ofSize: 16, weight: .medium)
		self.titleView.textColor = UIColor.htw.textHeadline
		self.titleView.numberOfLines = 4
		
        let stackView = UIStackView(arrangedSubviews: [self.counterView, self.priceView])
        stackView.axis = .horizontal
        stackView.spacing = Const.innerItemMargin
        
        self.contentView.add(self.imageView,
                             stackView,
                             self.titleView) { v in
                                v.translatesAutoresizingMaskIntoConstraints = false
        }
		
        NSLayoutConstraint.activate([
			// Meal imageView
			self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
			self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
			self.imageView.widthAnchor.constraint(equalToConstant: Const.imageWidth),

            // Counter and price stack view
            stackView.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: Const.innerItemMargin),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.innerItemMargin),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -Const.innerItemMargin),
			self.priceView.widthAnchor.constraint(greaterThanOrEqualToConstant: Const.priceMinWidth),
			
			// Title Label
			self.titleView.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: Const.innerItemMargin),
            self.titleView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
			self.titleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.innerItemMargin),
			self.titleView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -Const.innerItemMargin)
        ])
    }
	
    override func layoutSubviews() {
        super.layoutSubviews()
	}
	
    func update(viewModel: MealViewModel) {
        self.imageView.htw.loadImage(url: viewModel.imageUrl, loading: #imageLiteral(resourceName: "Meal-Placeholder"), fallback: #imageLiteral(resourceName: "Meal-Placeholder"))
        self.titleView.text = viewModel.title
        
        self.counterView.text = viewModel.counter
        self.counterView.isHidden = viewModel.counter == ""
        
		self.priceView.text = viewModel.price
		self.priceView.isHidden = viewModel.price == nil || viewModel.price == ""
		
        self.contentView.layoutIfNeeded()
    }

}
