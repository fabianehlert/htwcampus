//
//  FreeDayListCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 01.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

extension Event: Identifiable {}
struct FreeDayViewModel: ViewModel {
    let title: String
    init(model: Event) {
        self.title = model.name
    }
}

class FreeDayListCell: CollectionViewCell, Cell {
    
    enum Const {
        static let color = UIColor.white
        static let highlightedColor = UIColor.white
        
        static let textColor = UIColor.black
        
        static let highlightedScale: CGFloat = 0.97
        
        static let shadowRadius: CGFloat = 3
        static let highlightedShadowRadius: CGFloat = 1
        
        static let shadowOpacity: Float = 0.12
        static let highlightedShadowOpacity: Float = 0.3
        
        static let margin: CGFloat = 10
    }
    
    private let label = UILabel()
    
    override func initialSetup() {
        super.initialSetup()
        self.label.font = .systemFont(ofSize: 18, weight: .medium)
        self.label.textAlignment = .center
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 2
        self.contentView.clipsToBounds = true
        
        self.contentView.addSubview(self.label)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = Const.shadowRadius
        self.layer.shadowOpacity = Const.shadowOpacity
        
        // TODO: inject this!
        let widthConstraint = self.contentView.widthAnchor.constraint(equalToConstant: 351)
        
        NSLayoutConstraint.activate([
            widthConstraint,
            
            self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Const.margin),
            self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Const.margin),
            self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Const.margin),
            self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Const.margin),
            self.label.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
            ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    func update(viewModel: FreeDayViewModel) {
        self.label.text = viewModel.title
    }
    
}

// MARK: - Highlightable
extension FreeDayListCell: Highlightable {
    
    func highlight(animated: Bool) {
        let animations: () -> Void = {
            self.contentView.backgroundColor = Const.highlightedColor
            self.transform = CGAffineTransform.identity.scaledBy(x: Const.highlightedScale, y: Const.highlightedScale)
            self.layer.shadowRadius = Const.highlightedShadowRadius
            self.layer.shadowOpacity = Const.highlightedShadowOpacity
        }
        
        if !animated {
            animations()
        } else {
            let duration = 0.08
            
            let shadowRadiusAnimation = CABasicAnimation(keyPath: "shadowRadius")
            shadowRadiusAnimation.fromValue = Const.shadowRadius
            shadowRadiusAnimation.toValue = Const.highlightedShadowRadius
            shadowRadiusAnimation.duration = duration
            self.layer.add(shadowRadiusAnimation, forKey: "shadowRadiusAnimation")
            
            let shadowOpacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
            shadowOpacityAnimation.fromValue = Const.shadowOpacity
            shadowOpacityAnimation.toValue = Const.highlightedShadowOpacity
            shadowOpacityAnimation.duration = duration
            self.layer.add(shadowOpacityAnimation, forKey: "shadowOpacityAnimation")
            
            UIView.animate(withDuration: duration, animations: animations)
        }
    }
    
    func unhighlight(animated: Bool) {
        let animations: () -> Void = {
            self.contentView.backgroundColor = Const.color
            self.transform = CGAffineTransform.identity
            self.layer.shadowRadius = Const.shadowRadius
            self.layer.shadowOpacity = Const.shadowOpacity
        }
        
        if !animated {
            animations()
        } else {
            let duration = 0.18
            
            let shadowRadiusAnimation = CABasicAnimation(keyPath: "shadowRadius")
            shadowRadiusAnimation.fromValue = Const.highlightedShadowRadius
            shadowRadiusAnimation.toValue = Const.shadowRadius
            shadowRadiusAnimation.duration = duration
            self.layer.add(shadowRadiusAnimation, forKey: "shadowRadiusAnimation")
            
            let shadowOpacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
            shadowOpacityAnimation.fromValue = Const.highlightedShadowOpacity
            shadowOpacityAnimation.toValue = Const.shadowOpacity
            shadowOpacityAnimation.duration = duration
            self.layer.add(shadowOpacityAnimation, forKey: "shadowOpacityAnimation")
            
            UIView.animate(withDuration: duration, animations: animations)
        }
    }
    
}
