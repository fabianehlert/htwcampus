//
//  MealDetailViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 06.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import SafariServices

class MealDetailViewController: ViewController {
    
    enum Const {
        static let imageAspectRatio: CGFloat = 1.5
		static let priceMinWidth: CGFloat = 70
		static let margin: CGFloat = 30
		static let spacing: CGFloat = 12
    }
    
    private let viewModel: MealViewModel
    
    // MARK: - Views
	
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.alwaysBounceVertical = true
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()
	
	private lazy var imageContainerView: UIView = {
		let view = UIView()
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = .zero
		view.layer.shadowRadius = 12
		view.layer.shadowOpacity = 0.25
		view.clipsToBounds = false
		return view
	}()
	
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 20
		imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var counterLabel: BadgeLabel = {
        let label = BadgeLabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.htw.textHeadline
        label.backgroundColor = UIColor(hex: 0xE8E8E8)
        return label
    }()
	
	private lazy var priceLabel: BadgeLabel = {
		let label = BadgeLabel()
		label.font = .systemFont(ofSize: 18, weight: .semibold)
		label.textColor = UIColor.htw.textHeadline
		label.backgroundColor = UIColor(hex: 0xCFCFCF)
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
		
		self.setupUI()
        self.update(viewModel: self.viewModel)
    }
	
    override func initialSetup() {
        super.initialSetup()

		if UIDevice.current.userInterfaceIdiom == .pad {
			self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Loca.close, style: .done, target: self, action: #selector(dismissOrPopViewController))
		}

		if #available(iOS 11.0, *) {
			self.navigationItem.largeTitleDisplayMode = .never
		}
    }
	
	// MARK: - UI

	private func setupUI() {
		// ScrollView
		
		self.view.add(self.scrollView)
		
		let layoutGuide = self.view.htw.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			self.scrollView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
			self.scrollView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
			self.scrollView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
			self.scrollView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
		])
		
		// Image
		
		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		self.imageContainerView.add(self.imageView)
		
		NSLayoutConstraint.activate([
			self.imageView.leadingAnchor.constraint(equalTo: self.imageContainerView.leadingAnchor),
			self.imageView.topAnchor.constraint(equalTo: self.imageContainerView.topAnchor),
			self.imageView.trailingAnchor.constraint(equalTo: self.imageContainerView.trailingAnchor),
			self.imageView.bottomAnchor.constraint(equalTo: self.imageContainerView.bottomAnchor)
		])
		
		// SubViews
        
        let stackView = UIStackView(arrangedSubviews: [self.counterLabel, self.priceLabel])
        stackView.axis = .horizontal
        stackView.spacing = Const.spacing
		
        self.scrollView.add(self.imageContainerView,
                            stackView,
                            self.nameLabel,
                            self.moreButton) { v in
                                v.translatesAutoresizingMaskIntoConstraints = false
        }
		
		self.moreButton.addTarget(self, action: #selector(openMealWebsite), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			self.imageView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: Const.margin),
			self.imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: Const.margin),
			self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1 / Const.imageAspectRatio),
			self.imageView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 1, constant: -(2*Const.margin)),
			
            stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: Const.margin),
            stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: Const.margin),
			stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.scrollView.trailingAnchor, constant: -Const.margin),
			self.priceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Const.priceMinWidth),
			
			self.nameLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: Const.margin),
			self.nameLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Const.spacing),
			self.nameLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -Const.margin),
			self.nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.moreButton.topAnchor),
			self.nameLabel.widthAnchor.constraint(equalTo: self.imageView.widthAnchor),
			
			self.moreButton.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: Const.margin),
			self.moreButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: Const.margin),
			self.moreButton.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -Const.margin),
			self.moreButton.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -Const.margin),
			self.moreButton.heightAnchor.constraint(equalToConstant: 40),
			self.moreButton.widthAnchor.constraint(equalTo: self.imageView.widthAnchor)
		])
	}
	
    private func update(viewModel: MealViewModel) {
        self.title = viewModel.mensa
        self.imageView.htw.loadImage(url: viewModel.imageUrl, loading: #imageLiteral(resourceName: "Meal-Placeholder"), fallback: #imageLiteral(resourceName: "Meal-Placeholder"))
        self.nameLabel.text = viewModel.title
        
        self.counterLabel.text = viewModel.counter
        self.counterLabel.isHidden = viewModel.counter == ""
        
        self.priceLabel.text = viewModel.price
        self.priceLabel.isHidden =  viewModel.price == nil || viewModel.price == ""
		
        self.view.layoutIfNeeded()
    }
    
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

    // MARK: - Actions
    
    @objc private func openMealWebsite() {
        let safariVC = SFSafariViewController(url: self.viewModel.detailUrl)
        safariVC.preferredControlTintColor = UIColor.htw.blue
        self.present(safariVC, animated: true, completion: nil)
    }
    
}
