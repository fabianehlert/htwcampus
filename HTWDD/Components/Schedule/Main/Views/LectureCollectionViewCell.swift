//
//  LectureCollectionViewCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import Cartography

class LectureCollectionViewCell: CollectionViewCell, Cell {

    enum Const {
        static let color = UIColor.white
        static let highlightedColor = UIColor.white

        static let textColor = UIColor.black

        static let highlightedScale: CGFloat = 0.95

        static let shadowRadius: CGFloat = 4
        static let highlightedShadowRadius: CGFloat = 2

        static let shadowOpacity: Float = 0.15
        static let highlightedShadowOpacity: Float = 0.45
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = Const.textColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.textAlignment = .center
        label.textColor = Const.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let startLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()

    let endLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()

    override func initialSetup() {
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = Const.shadowRadius
        self.layer.shadowOpacity = Const.shadowOpacity

        let textContainer = UIView()

        self.contentView.backgroundColor = .white
        textContainer.addSubview(self.titleLabel)
        textContainer.addSubview(self.subtitleLabel)
        self.contentView.addSubview(textContainer)
        self.contentView.addSubview(self.startLabel)
        self.contentView.addSubview(self.endLabel)

        constrain(self.contentView, textContainer, self.titleLabel, self.subtitleLabel) { container, textContainer, title, subtitle in
            textContainer.leading == container.leading
            textContainer.trailing == container.trailing
            textContainer.centerY == container.centerY

            title.leading == textContainer.leading
            title.trailing == textContainer.trailing
            title.top == textContainer.top

            subtitle.top == title.bottom + 2
            subtitle.leading == title.leading
            subtitle.trailing == title.trailing
            subtitle.bottom == textContainer.bottom
        }

        constrain(self.contentView, self.startLabel, self.endLabel) { container, start, end in
            start.leading == container.leading + 2
            start.bottom == container.bottom

            end.trailing == container.trailing - 2
            end.bottom == container.bottom
        }
    }

    func update(viewModel: LectureViewModel) {
        self.titleLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
        self.startLabel.text = viewModel.start
        self.endLabel.text = viewModel.end
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

}

extension LectureCollectionViewCell: Highlightable {

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
