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
	
	private let disposeBag = DisposeBag()
	private let persistenceService = PersistenceService()

	@IBOutlet private weak var titleLabel: UILabel!
	
	// MARK: - ViewController lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .clear
		self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded // (self.challenges.count < 3) ? .compact : .expanded
		
		self.titleLabel?.text = "...loading..."
		
		self.loadActiveLecture()
            .map { lecture in
                return lecture?.name ?? "Could not find a lecture"
            }
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
	
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
