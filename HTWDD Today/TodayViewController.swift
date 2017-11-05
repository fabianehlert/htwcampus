//
//  TodayViewController.swift
//  HTWDD Today
//
//  Created by Fabian Ehlert on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: ViewController {
	
	// MARK: - ViewController lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .clear
		
		self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded // (self.challenges.count < 3) ? .compact : .expanded
    }
	
	override func initialSetup() {
		super.initialSetup()
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
