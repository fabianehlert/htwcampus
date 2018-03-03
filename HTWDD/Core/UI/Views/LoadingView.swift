//
//  LoadingView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 18.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class LoadingView: View {
    
    private enum Const {
        static let horizontalMargin: CGFloat = 20
        static let minVerticalMaegin: CGFloat = 30
    }
    
    private let label: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 30, weight: .semibold)
        l.textColor = .gray
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override func initialSetup() {
        super.initialSetup()
        
        self.label.text = Loca.loading
        
        let stackView = UIStackView(arrangedSubviews: [self.label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.add(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Const.horizontalMargin),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Const.horizontalMargin),
            stackView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, constant: -Const.minVerticalMaegin*2)
        ])
    }
    
}
