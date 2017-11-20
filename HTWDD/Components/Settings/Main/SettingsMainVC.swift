//
//  SettingsMainVC.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

protocol SettingsMainVCDelegate: class {
    func deleteAllData()
    func triggerScheduleOnboarding(completion: @escaping (ScheduleService.Auth) -> Void)
    func triggerGradeOnboarding(completion: @escaping (GradeService.Auth) -> Void)
	
	func showLicenses()
	func showGitHub()
}

class SettingsMainVC: TableViewController {
	
    var scheduleAuth: ScheduleService.Auth? {
        didSet {
            self.reset()
        }
    }
    
    var gradesAuth: GradeService.Auth? {
        didSet {
            self.reset()
        }
    }
    
    private lazy var dataSource = GenericBasicTableViewDataSource(data: self.settings)
	
	private var settings: [[SettingsItem]] {
		return [
			[
				SettingsItem(title: Loca.Settings.items.setSchedule.title,
							 subtitle: self.scheduleAuth.map { auth in Loca.Settings.items.setSchedule.subtitle(auth.year, auth.major, auth.group) },
							 action: self.showScheduleOnboarding()),
				SettingsItem(title: Loca.Settings.items.setGrades.title,
							 subtitle: self.gradesAuth.map { auth in Loca.Settings.items.setGrades.subtitle(auth.username) },
							 action: self.showGradeOnboarding())
			],
			[
				SettingsItem(title: "Lizenzen", action: self.showLicenses())
			],
			[
				SettingsItem(title: "HTW auf GitHub", action: self.showGitHub())
			],
			[
				SettingsItem(title: Loca.Settings.items.deleteAll,
							 action: self.showConfirmationAlert(title: Loca.attention,
																message: Loca.Settings.items.deleteAllConfirmationText,
																actionTitle: Loca.yes,
																action: { [weak self] in self?.delegate?.deleteAllData() })),
			]
		]
	}
    
    weak var delegate: SettingsMainVCDelegate?
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
	override func initialSetup() {
		super.initialSetup()
        
		self.title = Loca.Settings.title
		self.tabBarItem.image = #imageLiteral(resourceName: "Settings")
        
        self.dataSource.tableView = self.tableView
        self.dataSource.register(type: SettingsCell.self)
		
		self.tableView.separatorColor = UIColor.htw.lightGrey
	}
	
    private func reset() {
        self.dataSource = GenericBasicTableViewDataSource(data: self.settings)
        self.dataSource.tableView = self.tableView
        self.dataSource.register(type: SettingsCell.self)
        self.dataSource.invalidate()
    }
    
    private func showScheduleOnboarding() {
        self.delegate?.triggerScheduleOnboarding(completion: { [weak self] auth in
            self?.scheduleAuth = auth
        })
    }
    
    private func showGradeOnboarding() {
        self.delegate?.triggerGradeOnboarding(completion: { [weak self] auth in
            self?.gradesAuth = auth
        })
    }
	
	private func showLicenses() {
		self.delegate?.showLicenses()
	}
	
	private func showGitHub() {
		self.delegate?.showGitHub()
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
