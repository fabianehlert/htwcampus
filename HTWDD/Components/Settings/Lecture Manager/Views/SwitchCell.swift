//
//  SwitchCell.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 22.12.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

struct SwitchViewModel: ViewModel {
    let title: String
    let subtitle: String
    let on: Bool
    
    init(model: AppLecture) {
        self.title = model.lecture.name
        
        let begin = Loca.Schedule.Cell.time(model.lecture.begin.hour ?? 0, model.lecture.begin.minute ?? 0)
        let end = Loca.Schedule.Cell.time(model.lecture.end.hour ?? 0, model.lecture.end.minute ?? 0)
        
        var s = Loca.Schedule.Settings.Cell.subtitle(model.lecture.week.stringValue, begin, end)
        if let weeks = model.lecture.weeks {
            let w = weeks.map { "\($0)" }.joined(separator: ", ")
            s.append("\n\(Loca.CalendarWeek.short): \(w)")
        }
        self.subtitle = s
        
        self.on = !model.hidden
    }
}

class SwitchCell: TableViewCell, Cell {
 
    enum Const {
        static let margin: CGFloat = 15
        static let verticalMargin: CGFloat = 8
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.htw.grey
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activeSwitch: UISwitch = {
        let s = UISwitch()
        return s
    }()
    
    // MARK: - Init
    
    override func initialSetup() {
        super.initialSetup()
        
        self.selectionStyle = .none
        
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        stackView.axis = .vertical
        
        let views: [UIView] = [stackView, self.activeSwitch]
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                               constant: Const.margin),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                           constant: Const.verticalMargin),
            stackView.trailingAnchor.constraint(equalTo: self.activeSwitch.leadingAnchor,
                                                constant: -Const.margin),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                              constant: -Const.verticalMargin),
            
            self.activeSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                        constant: -Const.margin),
            self.activeSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }

    func update(viewModel: SwitchViewModel) {
        self.titleLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
        self.activeSwitch.isOn = viewModel.on
    }

}
