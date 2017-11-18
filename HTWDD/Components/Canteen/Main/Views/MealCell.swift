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
        if model.counter.isEmpty {
            self.counter = Loca.Canteen.noCounter
        } else {
            self.counter = model.counter
        }
        
        self.detailUrl = model.url
        self.imageUrl = model.imageURL
    }
}

class MealCell: FlatCollectionViewCell, Cell {

    enum Const {
		static let height: CGFloat = 122
		static let imageWidth: CGFloat = 100
		
		static let innerItemMargin: CGFloat = 8
        static let verticalMargin: CGFloat = 15
        static let colorViewHorizontalMargin: CGFloat = 10
    }
    
    private lazy var imageView = UIImageView()
    private lazy var badgeView = BadgeLabel()
    private lazy var titleView = UILabel()
    private lazy var priceView = UILabel()

    override func initialSetup() {
        super.initialSetup()
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
		
		self.priceView.font = .systemFont(ofSize: 13, weight: .medium)
		self.priceView.textColor = UIColor.htw.textHeadline
		self.priceView.textAlignment = .right
		self.priceView.backgroundColor = .white
		self.priceView.alpha = 0.8

		self.badgeView.font = .systemFont(ofSize: 13, weight: .semibold)
        self.badgeView.textColor = UIColor.htw.textHeadline
		self.badgeView.backgroundColor = UIColor.htw.lightGrey

		self.titleView.font = .systemFont(ofSize: 16, weight: .medium)
		self.titleView.textColor = UIColor.htw.textHeadline
		self.titleView.numberOfLines = 0

		let views: [UIView] = [self.imageView, self.badgeView, self.titleView, self.priceView]
        views.forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
			self.contentView.heightAnchor.constraint(equalToConstant: Const.height),
			
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
			self.badgeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.innerItemMargin),
			
			// titleView
			self.titleView.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: Const.innerItemMargin),
			self.titleView.topAnchor.constraint(equalTo: self.badgeView.bottomAnchor, constant: Const.innerItemMargin),
			self.titleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.innerItemMargin),
			self.titleView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -Const.innerItemMargin)
        ])
		
		// TODO:
    }
	
    override func layoutSubviews() {
        super.layoutSubviews()
	}
	
    func update(viewModel: MealViewModel) {
        self.imageView.htw.loadImage(url: viewModel.imageUrl, loading: #imageLiteral(resourceName: "Canteen"), fallback: #imageLiteral(resourceName: "Exams"))
        self.titleView.text = viewModel.title
        self.priceView.text = viewModel.price
        self.badgeView.text = viewModel.counter
    }

}

extension MealCell: HeightCalculator {
	static func height(for width: CGFloat, viewModel: MealViewModel) -> CGFloat {
		let cell = MealCell()
		cell.update(viewModel: viewModel)
		let size = cell.contentView.systemLayoutSizeFitting(CGSize(width: width, height: 0),
															withHorizontalFittingPriority: .required,
															verticalFittingPriority: .fittingSizeLevel)
		return size.height
	}
}
