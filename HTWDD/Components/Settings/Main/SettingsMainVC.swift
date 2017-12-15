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
	
	func showLicense(name: String)
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
	
	private var settings: [(String, [SettingsItem])] {
		return [
			("", [
				SettingsItem(title: Loca.Settings.items.setSchedule.title,
							 subtitle: self.scheduleAuth.map { auth in Loca.Settings.items.setSchedule.subtitle(auth.year, auth.major, auth.group) },
							 action: self.showScheduleOnboarding()),
				SettingsItem(title: Loca.Settings.items.setGrades.title,
							 subtitle: self.gradesAuth.map { auth in Loca.Settings.items.setGrades.subtitle(auth.username) },
							 action: self.showGradeOnboarding())
			]),
            (Loca.Settings.sections.weAreOpenSource, [
				SettingsItem(title: Loca.Settings.items.github, action: self.showGitHub())
			]),
            (Loca.Settings.sections.openSource, [
                SettingsItem(title: "RxSwift", action: self.showLicense(name: "RxSwift-license.html")),
                SettingsItem(title: "Marshal", action: self.showLicense(name: "Marshal-license.html")),
                SettingsItem(title: "KeychainAccess", action: self.showLicense(name: "KeychainAccess-license.html"))
            ]),
			(Loca.Settings.sections.deleteAll, [
				SettingsItem(title: Loca.Settings.items.deleteAll,
							 action: self.showConfirmationAlert(title: Loca.attention,
																message: Loca.Settings.items.deleteAllConfirmationText,
																actionTitle: Loca.yes,
																action: { [weak self] in self?.delegate?.deleteAllData() })),
			])
		]
	}
    
    private lazy var footerView: UIView = {
        let h: CGFloat = 100
        
        let love = NSAttributedString(string: Loca.Settings.credits,
                                      attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium),
                                                   .foregroundColor: UIColor.htw.grey])
        let version = NSAttributedString(string: String(format: "\n%@ (%@)", Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String, Bundle.main.infoDictionary!["CFBundleVersion"] as! String),
                                         attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium),
                                                      .foregroundColor: UIColor.htw.grey])

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let text = NSMutableAttributedString()
        text.append(love)
        text.append(version)
        text.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
        
        let loveLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.width, height: h))
        loveLabel.attributedText = text
        loveLabel.numberOfLines = 2
        loveLabel.textAlignment = .center
        loveLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth, .flexibleHeight]

        return loveLabel
    }()
    
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
	
	private func showLicense(name: String) {
		self.delegate?.showLicense(name: name)
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

        self.tableView.tableFooterView = self.footerView
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
