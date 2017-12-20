//
//  FlatCollectionViewCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 02.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class FlatCollectionViewCell: CollectionViewCell {
    
    enum Const {
        static let color = UIColor.white
        static let highlightedColor = UIColor.white
        
        static let highlightedScale: CGFloat = 0.97
        
        static let shadowRadius: CGFloat = 5
        static let highlightedShadowRadius: CGFloat = 1
        
        static let shadowOpacity: Float = 0.15
        static let highlightedShadowOpacity: Float = 0.15
    }
    
	var isHighlightable: Bool = true
	
    override func initialSetup() {
        super.initialSetup()
        
        self.contentView.backgroundColor = Const.color
        self.contentView.layer.cornerRadius = 6
        self.contentView.clipsToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = Const.shadowRadius
        self.layer.shadowOpacity = Const.shadowOpacity
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
}

// MARK: - Highlightable
extension FlatCollectionViewCell: Highlightable {
    
    func highlight(animated: Bool) {
		guard isHighlightable else { return }
        let animations: () -> Void = {
            self.contentView.backgroundColor = Const.highlightedColor
            self.transform = CGAffineTransform.identity.scaledBy(x: Const.highlightedScale, y: Const.highlightedScale)
            self.layer.shadowRadius = Const.highlightedShadowRadius
            self.layer.shadowOpacity = Const.highlightedShadowOpacity
        }
        
        if !animated {
            animations()
        } else {
            let duration = 0.12
            
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
		guard isHighlightable else { return }
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
