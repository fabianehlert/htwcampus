//
//  SettingsMainVC.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class SettingsMainVC: ViewController {
	
	override func initialSetup() {
		super.initialSetup()
		
		self.title = Loca.Settings.title
		self.tabBarItem.image = #imageLiteral(resourceName: "Settings")
	}
	
	// MARK: - ViewController lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		self.refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
//		self.refreshControl.tintColor = .white
		
		if #available(iOS 11.0, *) {
			self.navigationController?.navigationBar.prefersLargeTitles = true
			self.navigationItem.largeTitleDisplayMode = .automatic
			
			// self.collectionView.refreshControl = self.refreshControl
		} else {
			// self.collectionView.addSubview(self.refreshControl)
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

}
