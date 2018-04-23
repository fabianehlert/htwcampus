//
//  TodayViewController.swift
//  HTWDD Today
//
//  Created by Fabian Ehlert on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NotificationCenter

class TodayViewController: ViewController {
	
	// - Private Properties
	
	private var lecture: AppLecture? {
		didSet {
            if self.lecture != nil {
                self.updateUI()
            } else {
                self.updateEmptyMessage(hidden: false)
            }
		}
	}
	
	private let disposeBag = DisposeBag()
	private let persistenceService = PersistenceService()
	
	// -- Outlets
	
	@IBOutlet private weak var noLectureLabel: UILabel!
	
	@IBOutlet private weak var containerView: UIView!
	
	@IBOutlet private weak var beginLabel: UILabel!
	@IBOutlet private weak var endLabel: UILabel!
	@IBOutlet private weak var colorView: UIView! {
		didSet {
			self.colorView.layer.cornerRadius = 2
		}
	}
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var professorLabel: UILabel!
	@IBOutlet private weak var typeLabel: BadgeLabel!
	@IBOutlet private weak var roomLabel: BadgeLabel!
	
	// MARK: - ViewController lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
				
		self.view.backgroundColor = .clear
		self.extensionContext?.widgetLargestAvailableDisplayMode = .compact
		self.addGestureRecognizer()
        
		self.loadActiveLecture()
			.subscribe(onNext: { [weak self] l in
			self?.lecture = l
		}).disposed(by: self.disposeBag)
	}
	
	// MARK: - UI
	
	private func updateUI() {
		guard let lecture = self.lecture else {
			self.updateEmptyMessage(hidden: false)
			return
		}
		
		self.updateEmptyMessage(hidden: true)
		
		let viewModel = LectureViewModel(model: lecture)
		self.beginLabel.text = viewModel.begin
		self.endLabel.text = viewModel.end
		self.colorView.backgroundColor = UIColor(hex: viewModel.color)
		self.titleLabel.text = viewModel.longTitle
		self.professorLabel.text = viewModel.professor
		self.typeLabel.text = viewModel.type
		self.roomLabel.text = viewModel.room
	}
	
	private func updateEmptyMessage(hidden: Bool) {
		self.noLectureLabel.text = Loca.Schedule.NextLecture.unavailable
		self.noLectureLabel.isHidden = hidden
		self.containerView.isHidden = !hidden
	}
	
	// MARK: - Private
	
	private func loadActiveLecture() -> Observable<AppLecture?> {
		
		let originDate = Date()
		let weekDay = originDate.weekday
		let weekNumber = originDate.weekNumber
		
		func currentLecture(lectures: [AppLecture]) -> AppLecture? {
			let components = Date().components
			// sort lectures from late to early
			let sortedLectures = lectures.sorted(by: { $0.lecture.begin > $1.lecture.begin })
			var currentLecture: AppLecture? = nil
			for l in sortedLectures {
				if components.timeBetween(start: l.lecture.begin, end: l.lecture.end.minus(minutes: 45)) {
					return l
				}
				if l.lecture.end.isBefore(other: components) {
					return currentLecture
				}
				currentLecture = l
			}
			return currentLecture
		}
		
		func filterLecturesForToday(semester: SemesterInformation, lectures: [AppLecture]) -> [AppLecture] {
			guard semester.lecturesContains(date: originDate) else {
				return []
			}
			
			if semester.freeDayContains(date: originDate) != nil {
				return []
			}
			
			return lectures.filter { lecture in
				let weekEvenOddValidation = lecture.lecture.week.validate(weekNumber: weekNumber)
				let weekOnlyValidation = lecture.lecture.weeks?.contains(weekNumber) ?? true
				return weekEvenOddValidation && weekOnlyValidation
			}
		}
		
		return self.persistenceService.loadScheduleCache()
			.map { information in
				guard let currentSemester = SemesterInformation.information(date: originDate, input: information.semesters) else {
					return nil
				}
				let filtered = filterLecturesForToday(semester: currentSemester, lectures: information.lectures[weekDay] ?? [])
				return currentLecture(lectures: filtered)
		}
	}
	
    // MARK: - UIGestureRecognizer
    
    private func addGestureRecognizer() {
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        self.containerView.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - URL
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        extensionContext?.open(URL(string:"htwdd://schedule")!, completionHandler: nil)
    }
}

// MARK: - NCWidgetProviding
extension TodayViewController: NCWidgetProviding {
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		completionHandler(NCUpdateResult.newData)
	}
	
	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
		let compactSize = self.extensionContext?.widgetMaximumSize(for: .compact) ?? CGSize.zero
		switch activeDisplayMode {
		case .compact:
			self.preferredContentSize = compactSize
		case .expanded:
			self.preferredContentSize = CGSize(width: compactSize.width, height: compactSize.height * 2)
		}
	}
}
