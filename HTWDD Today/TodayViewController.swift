//
//  TodayViewController.swift
//  HTWDD Today
//
//  Created by Fabian Ehlert on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import NotificationCenter

class TodayViewController: ViewController {
	
	private let disposeBag = DisposeBag()
	private let persistenceService = PersistenceService()

	@IBOutlet private weak var titleLabel: UILabel?
	
	// MARK: - ViewController lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .clear
		self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded // (self.challenges.count < 3) ? .compact : .expanded
		
		self.titleLabel?.text = "...loading..."
		
		self.loadPersistedAuth { [weak self] auth, _ in
			self?.titleLabel?.text = auth?.major ?? "Nothing here..."
		}
    }
	
	private func loadPersistedAuth(completion: @escaping (ScheduleService.Auth?, GradeService.Auth?) -> Void) {
		self.persistenceService.load()
			.take(1)
			.subscribe(onNext: { res in
				completion(res.schedule, res.grades)
			}, onError: { _ in
				completion(nil, nil)
			})
			.disposed(by: self.disposeBag)
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
