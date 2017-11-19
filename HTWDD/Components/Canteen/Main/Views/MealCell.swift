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
    let counter: String
    
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
		
		static let innerItemMargin: CGFloat = 8
        static let verticalMargin: CGFloat = 15
        static let colorViewHorizontalMargin: CGFloat = 10
    }
    
    private lazy var badgeZeroHeightConstraint: NSLayoutConstraint = {
        let c = self.badgeView.heightAnchor.constraint(equalToConstant: 0)
        c.isActive = false
        return c
    }()
    private lazy var badgeTopConstraint: NSLayoutConstraint = {
        let c = self.badgeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.innerItemMargin)
        return c
    }()
    
    private lazy var imageView = UIImageView()
    private lazy var badgeView = BadgeLabel()
    private lazy var titleView = UILabel()
    private lazy var priceView = BadgeLabel()

    override func initialSetup() {
        super.initialSetup()
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
		
		self.priceView.font = .systemFont(ofSize: 13, weight: .semibold)
		self.priceView.textColor = UIColor.htw.textHeadline
		self.priceView.backgroundColor = .white
        self.priceView.roundedCorners = [.topRight, .bottomRight]

		self.badgeView.font = .systemFont(ofSize: 13, weight: .semibold)
        self.badgeView.textColor = UIColor.htw.textHeadline
		self.badgeView.backgroundColor = UIColor.htw.lightGrey

		self.titleView.font = .systemFont(ofSize: 16, weight: .medium)
		self.titleView.textColor = UIColor.htw.textHeadline
		self.titleView.numberOfLines = 0

		let views: [UIView] = [self.imageView, self.priceView, self.badgeView, self.titleView]
        views.forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
			// imageView
			self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
			self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
			self.imageView.widthAnchor.constraint(equalToConstant: Const.imageWidth),
			
			// priceView
			self.priceView.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor),
			self.priceView.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -Const.innerItemMargin),

			// badgeView (station)
			self.badgeView.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: Const.innerItemMargin),
			self.badgeTopConstraint,
			
			// titleView
			self.titleView.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: Const.innerItemMargin),
            self.titleView.topAnchor.constraint(equalTo: self.badgeView.bottomAnchor, constant: 4),
			self.titleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.innerItemMargin),
			self.titleView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -Const.innerItemMargin)
        ])
    }
	
    override func layoutSubviews() {
        super.layoutSubviews()
	}
	
    func update(viewModel: MealViewModel) {
        self.imageView.htw.loadImage(url: viewModel.imageUrl, loading: #imageLiteral(resourceName: "Canteen"), fallback: #imageLiteral(resourceName: "Meal-Placeholder"))
        self.titleView.text = viewModel.title
        self.priceView.text = viewModel.price
        self.badgeView.text = viewModel.counter
        
        self.badgeZeroHeightConstraint.isActive = viewModel.counter.isEmpty ? true : false
        self.badgeTopConstraint.constant = viewModel.counter.isEmpty ? 0 : Const.innerItemMargin
        
        self.contentView.layoutIfNeeded()
    }

}
