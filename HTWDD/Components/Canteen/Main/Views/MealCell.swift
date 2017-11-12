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
    let price: String?
    let counter: String
    
    let detailUrl: URL
    let imageUrl: URL?
    init(model: Meal) {
        self.title = model.title
        self.price = model.studentPrice?.htw.currencyString
        self.counter = model.counter
        
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
    
    private lazy var badgeView = BadgeLabel()
    private lazy var colorView = UIView()
    private lazy var titleView = UILabel()
    private lazy var priceView = UILabel()

    override func initialSetup() {
        super.initialSetup()
        
        self.badgeView.backgroundColor = UIColor.htw.mediumGrey
        self.badgeView.textColor = UIColor.white
        self.badgeView.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        self.colorView.backgroundColor = UIColor.htw.green

        self.priceView.textAlignment = .right
        self.priceView.textColor = UIColor.htw.mediumGrey
        self.priceView.font = .systemFont(ofSize: Const.markFontSize, weight: .medium)
        
        self.titleView.font = .systemFont(ofSize: Const.titleFontSize, weight: .medium)
        self.titleView.numberOfLines = 4
        self.titleView.lineBreakMode = .byWordWrapping
        self.titleView.textColor = UIColor.htw.darkGrey

        [self.badgeView, self.colorView, self.titleView, self.priceView].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // badge view
            self.badgeView.topAnchor.constraint(equalTo: self.priceView.topAnchor),
            self.badgeView.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.horizontalMargin),
            
            // titleView
            self.titleView.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: Const.horizontalMargin),
            self.titleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.horizontalMargin),
            self.titleView.topAnchor.constraint(equalTo: self.badgeView.bottomAnchor, constant: Const.innerItemMargin),
            
            // grade view
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
        self.titleView.text = viewModel.title
        self.priceView.text = viewModel.price
        self.badgeView.text = viewModel.counter
    }

}

extension MealCell: HeightCalculator {
    static func height(for width: CGFloat, viewModel: MealViewModel) -> CGFloat {
        let cell = MealCell()
        cell.update(viewModel: viewModel)
        return cell.systemLayoutSizeFitting(CGSize(width: width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow).height
    }
}
