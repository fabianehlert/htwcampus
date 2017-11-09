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
	
	private var lecture: Lecture? {
		didSet {
			self.updateUI()
		}
	}
	
	private let disposeBag = DisposeBag()
	private let persistenceService = PersistenceService()
	
	// -- Outlets
	
	@IBOutlet private weak var beginLabel: UILabel!
	@IBOutlet private weak var endLabel: UILabel!
	@IBOutlet private weak var colorView: UIView! {
		didSet {
			self.colorView.layer.cornerRadius = 2
		}
	}
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var professorLabel: UILabel!
	@IBOutlet private weak var typeLabel: UILabel!
	@IBOutlet private weak var roomLabel: UILabel!
	
	// MARK: - ViewController lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// TODO: Remove before flight
		// Replace with a valid lecture name and see if defaults are available.
		let name = "Betriebssysteme 1"
		if let data = UserDefaults.htw?.data(forKey: ScheduleService.lectureColorsKey),
			let colors = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Int: UInt] {
			print("Lecture color: \(colors[name.hashValue])")
		} else {
			print("No Color data available.")
		}
		
		self.view.backgroundColor = .clear
		self.extensionContext?.widgetLargestAvailableDisplayMode = .compact // (self.challenges.count < 3) ? .compact : .expanded
		
		self.loadActiveLecture()
			.subscribe(onNext: { [weak self] l in
			self?.lecture = l
		}).disposed(by: self.disposeBag)
	}
	
	// MARK: - UI
	
	private func updateUI() {
		guard let lecture = self.lecture else {
			self.showEmptyMessage()
			return
		}
		
		let viewModel = LectureViewModel(model: lecture)
		self.beginLabel.text = viewModel.begin
		self.endLabel.text = viewModel.end
		self.colorView.backgroundColor = UIColor(hex: viewModel.color)
		self.titleLabel.text = viewModel.longTitle
		self.professorLabel.text = viewModel.professor
		self.typeLabel.text = viewModel.type
		self.roomLabel.text = viewModel.room
	}
	
	private func showEmptyMessage() {
		// TODO: Empty message
	}
	
	// MARK: - Private
	
	private func loadActiveLecture() -> Observable<Lecture?> {
		
		let originDate = Date()
		let weekDay = originDate.weekday
		let weekNumber = originDate.weekNumber
		
		func currentLecture(lectures: [Lecture]) -> Lecture? {
			let components = Date().components
			// sort lectures from late to early
			let sortedLectures = lectures.sorted(by: { $0.begin > $1.begin })
			var currentLecture: Lecture? = nil
			for l in sortedLectures {
				if components.timeBetween(start: l.begin, end: l.end) {
					return l
				}
				if l.end.isBefore(other: components) {
					return currentLecture
				}
				currentLecture = l
			}
			return currentLecture
		}
		
		func filterLecturesForToday(semester: SemesterInformation, lectures: [Lecture]) -> [Lecture] {
			guard semester.lecturesContains(date: originDate) else {
				return []
			}
			
			if semester.freeDayContains(date: originDate) != nil {
				return []
			}
			
			return lectures.filter { lecture in
				let weekEvenOddValidation = lecture.week.validate(weekNumber: weekNumber)
				let weekOnlyValidation = lecture.weeks?.contains(weekNumber) ?? true
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
			// self.preferredContentSize = (self.challenges.count < 3) ? compactSize : CGSize(width: compactSize.width, height: compactSize.height * 2)
		}
	}
}
