//
//  CanteenDetailView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 06.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class CanteenDetailViewController: ViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let viewModel: MealViewModel
    init(viewModel: MealViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialSetup() {
        super.initialSetup()
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subviews = [self.imageView]
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        let layoutGuide = self.view.htw.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: layoutGuide.topAnchor)
        ])
        
        self.update(viewModel: self.viewModel)
    }
    
    private func update(viewModel: MealViewModel) {
        self.title = viewModel.mensa
        self.imageView.htw.loadImage(url: viewModel.imageUrl, loading: #imageLiteral(resourceName: "Canteen"), fallback: #imageLiteral(resourceName: "Exams"))
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
}
