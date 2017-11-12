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
        static let horizontalMargin: CGFloat = 10
        static let verticalMargin: CGFloat = 15
        static let innerItemMargin: CGFloat = 4
        static let colorViewHorizontalMargin: CGFloat = 10
        
        static let markFontSize: CGFloat = 20
        static let titleFontSize: CGFloat = 18
    }
    
    private lazy var imageView = UIImageView()
    private lazy var badgeView = BadgeLabel()
    private lazy var colorView = UIView()
    private lazy var titleView = UILabel()
    private lazy var priceView = UILabel()

    override func initialSetup() {
        super.initialSetup()
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        
        self.badgeView.backgroundColor = UIColor.htw.mediumGrey
        self.badgeView.textColor = UIColor.white
        self.badgeView.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        self.colorView.backgroundColor = UIColor.htw.green

        self.priceView.textAlignment = .right
        self.priceView.textColor = UIColor.htw.mediumGrey
        self.priceView.font = .systemFont(ofSize: Const.markFontSize, weight: .medium)
        
        self.titleView.font = .systemFont(ofSize: Const.titleFontSize, weight: .medium)
        self.titleView.numberOfLines = 0
        self.titleView.textColor = UIColor.htw.darkGrey

        [self.imageView, self.badgeView, self.colorView, self.titleView, self.priceView].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // image view
            self.imageView.topAnchor.constraint(equalTo: self.priceView.topAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.horizontalMargin),
            self.imageView.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.horizontalMargin),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor, multiplier: 8/5),
            
            // badge view
            self.badgeView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: Const.innerItemMargin),
            self.badgeView.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.horizontalMargin),
            
            // titleView
            self.titleView.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.horizontalMargin),
            self.titleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.horizontalMargin),
            self.titleView.topAnchor.constraint(equalTo: self.badgeView.bottomAnchor, constant: Const.innerItemMargin),
            self.titleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.verticalMargin),
            
            // price view
            self.priceView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.horizontalMargin),
            self.priceView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.verticalMargin),
            self.priceView.widthAnchor.constraint(equalToConstant: 80),
            self.priceView.heightAnchor.constraint(equalToConstant: 30),
            
            // Color view
            self.colorView.leadingAnchor.constraint(equalTo: self.priceView.trailingAnchor, constant: Const.horizontalMargin),
            self.colorView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.colorViewHorizontalMargin),
            self.colorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.colorViewHorizontalMargin),
            self.colorView.widthAnchor.constraint(equalToConstant: 5),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorView.layer.cornerRadius = 2
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
