//
//  LectureCollectionViewCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

extension Lecture: Identifiable {}

struct LectureViewModel: ViewModel {
    private let model: Lecture

    var title: String {
        return model.tag ?? model.name
    }

    init(model: Lecture) {
        self.model = model
    }
}

class LectureCollectionViewCell: CollectionViewCell, Cell {

    enum Const {
        static let color = UIColor.white
        static let highlightedColor = UIColor.white

        static let textColor = UIColor.black
        static let highlightedTextColor = UIColor.black

        static let highlightedScale: CGFloat = 0.98

        static let shadowRadius: CGFloat = 3.5
        static let highlightedShadowRadius: CGFloat = 2.5

        static let shadowOpacity: Float = 0.25
        static let highlightedShadowOpacity: Float = 0.3
    }

    let label = UILabel()

    override func initialSetup() {
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = Const.shadowRadius
        self.layer.shadowOpacity = Const.shadowOpacity

        self.label.frame = self.contentView.bounds
        self.label.textAlignment = .center
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.label)
    }

    func update(viewModel: LectureViewModel) {
        self.label.text = viewModel.title
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
            self.label.textColor = Const.highlightedTextColor
            self.transform = CGAffineTransform.identity.scaledBy(x: Const.highlightedScale, y: Const.highlightedScale)
            self.layer.shadowRadius = Const.highlightedShadowRadius
            self.layer.shadowOpacity = Const.highlightedShadowOpacity
        }
        if !animated {
            animations()
        } else {
            UIView.animate(withDuration: 0.3, animations: animations)
        }
    }

    func unhighlight(animated: Bool) {
        let animations: () -> Void = {
            self.contentView.backgroundColor = Const.color
            self.label.textColor = Const.textColor
            self.transform = CGAffineTransform.identity
            self.layer.shadowRadius = Const.shadowRadius
            self.layer.shadowOpacity = Const.shadowOpacity
        }
        if !animated {
            animations()
        } else {
            UIView.animate(withDuration: 0.3, animations: animations)
        }
    }

}
