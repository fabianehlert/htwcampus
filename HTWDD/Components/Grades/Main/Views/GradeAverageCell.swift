//
//  GradeAverageCell.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 25.02.18.
//  Copyright © 2018 HTW Dresden. All rights reserved.
//

import UIKit

struct GradeAverageViewModel: ViewModel {
    let text: NSAttributedString
    init(model: GradeAverage) {
        let title = NSAttributedString(string: String(format: "∅ %.2f", model.average),
                                       attributes: [.foregroundColor: UIColor.htw.textHeadline, .font: UIFont.systemFont(ofSize: 30, weight: .medium)])
        let subtitle = NSAttributedString(string: Loca.Grades.totalCredits(model.credits),
                                          attributes: [.foregroundColor: UIColor.htw.mediumGrey, .font: UIFont.systemFont(ofSize: 15, weight: .medium)])
        self.text = title + "\n" + subtitle
    }
}

class GradeAverageCell: CollectionViewCell {
    
    private let averageLabel = UILabel(frame: .zero)
    
    override func initialSetup() {
        super.initialSetup()
        
        self.averageLabel.font = .systemFont(ofSize: 30, weight: .medium)
        self.averageLabel.textColor = UIColor.htw.mediumGrey
        self.averageLabel.numberOfLines = 2
        self.averageLabel.textAlignment = .center
        
        self.contentView.add(self.averageLabel)
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.averageLabel.center = self.contentView.center
    }
    
}

extension GradeAverageCell: Cell {
    
    func update(viewModel: GradeAverageViewModel) {
        self.averageLabel.attributedText = viewModel.text
        self.averageLabel.sizeToFit()
    }
    
}
