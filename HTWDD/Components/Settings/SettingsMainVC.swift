//
//  SettingsMainVC.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

struct SettingsItem: Identifiable {
    let title: String
    let action: () -> ()
    
    init(title: String, action: @escaping @autoclosure () -> ()) {
        self.title = title
        self.action = action
    }
}

protocol SettingsMainVCDelegate: class {
    func deleteAllData()
}

class SettingsMainVC: TableViewController {
	
    private lazy var dataSource = GenericBasicTableViewDataSource(data: self.settings)
    
    private lazy var settings: [SettingsItem] = [
        SettingsItem(title: Loca.Settings.items.deleteAll, action: self.showConfirmationAlert(title: Loca.attention, message: Loca.Settings.items.deleteAllConfirmationText, actionTitle: Loca.yes, action: { [weak self] in self?.delegate?.deleteAllData() }))
    ]
    
    weak var delegate: SettingsMainVCDelegate?
    
	override func initialSetup() {
		super.initialSetup()
        
		self.title = Loca.Settings.title
		self.tabBarItem.image = #imageLiteral(resourceName: "Settings")
        
        self.dataSource.tableView = self.tableView
	}
	
	// MARK: - ViewController lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if #available(iOS 11.0, *) {
			self.navigationController?.navigationBar.prefersLargeTitles = true
			self.navigationItem.largeTitleDisplayMode = .automatic
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
    
    private func showConfirmationAlert(title: String?, message: String?, actionTitle: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Loca.cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in action() }))
        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.dataSource.data(at: indexPath)
        item.action()
    }
}
