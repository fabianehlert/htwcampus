//
//  CanteenDetailView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 06.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import SafariServices

class CanteenDetailViewController: ViewController {
    
    enum Const {
        static let imageAspectRatio: CGFloat = 1.5
        static let margin: CGFloat = 16
    }
    
    private let viewModel: MealViewModel
    
    // MARK: - Views
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var priceLabel: BadgeLabel = {
        let label = BadgeLabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.htw.textHeadline
        label.backgroundColor = .white
        label.roundedCorners = [.topRight, .bottomRight]
        return label
    }()

    private lazy var counterLabel: BadgeLabel = {
        let label = BadgeLabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.htw.textHeadline
        label.backgroundColor = UIColor.htw.lightGrey
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.htw.textHeadline
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var moreButton: ReactiveButton = {
        let button = ReactiveButton()
        button.setTitle(Loca.Canteen.Meal.more, for: .normal)
        button.setTitleColor(UIColor.htw.blue, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private lazy var counterZeroHeightConstraint: NSLayoutConstraint = {
        let c = self.counterLabel.heightAnchor.constraint(equalToConstant: 0)
        c.isActive = false
        return c
    }()
    private lazy var counterTopConstraint: NSLayoutConstraint = {
        let c = self.counterLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: Const.margin)
        return c
    }()

    // MARK: - Init
    
    init(viewModel: MealViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Loca.close, style: .done, target: self, action: #selector(dismissOrPopViewController))
        }
        
        let subviews: [UIView] = [self.imageView, self.priceLabel, self.counterLabel, self.nameLabel, self.moreButton]
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }

        self.moreButton.addTarget(self, action: #selector(openMealWebsite), for: .touchUpInside)
        
        let layoutGuide = self.view.htw.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor, multiplier: Const.imageAspectRatio),
            
            self.priceLabel.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor),
            self.priceLabel.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -Const.margin),
            
            self.counterLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Const.margin),
            counterTopConstraint,
            
            self.nameLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Const.margin),
            self.nameLabel.topAnchor.constraint(equalTo: self.counterLabel.bottomAnchor, constant: Const.margin),
            self.nameLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Const.margin),
            self.nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.moreButton.topAnchor),
            
            self.moreButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Const.margin),
            self.moreButton.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -Const.margin),
            self.moreButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Const.margin),
            self.moreButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.update(viewModel: self.viewModel)
    }
    
    // MARK: - UI
    
    override func initialSetup() {
        super.initialSetup()
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    private func update(viewModel: MealViewModel) {
        self.title = viewModel.mensa
        self.imageView.htw.loadImage(url: viewModel.imageUrl, loading: #imageLiteral(resourceName: "Canteen"), fallback: #imageLiteral(resourceName: "Meal-Placeholder"))
        self.priceLabel.text = viewModel.price
        self.counterLabel.text = viewModel.counter
        self.nameLabel.text = viewModel.title
        
        self.counterZeroHeightConstraint.isActive = viewModel.counter.isEmpty ? true : false
        self.counterTopConstraint.constant = viewModel.counter.isEmpty ? 0 : Const.margin

        self.view.layoutIfNeeded()
    }
    
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

    // MARK: - Actions
    
    @objc private func openMealWebsite() {
        let safariVC = SFSafariViewController(url: self.viewModel.detailUrl)
        if #available(iOS 10.0, *) {
            safariVC.preferredControlTintColor = UIColor.htw.blue
        }
        self.present(safariVC, animated: true, completion: nil)
    }
    
}
