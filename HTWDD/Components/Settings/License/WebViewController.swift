//
//  WebViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 20.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: ViewController {

	private var fileName: String
	private var webView: WKWebView
	
	// MARK: - Init
	
	init(fileName: String) {
		self.fileName = fileName
		self.webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration.htw.config)
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	// MARK: - ViewController lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
//		self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
		
		if #available(iOS 11.0, *) {
			self.navigationItem.largeTitleDisplayMode = .never
		}
		
		self.webView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(self.webView)
		
		let guide = self.view.htw.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			self.webView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
			self.webView.topAnchor.constraint(equalTo: guide.topAnchor),
			self.webView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
			self.webView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
		])
		
		self.loadLocalHTML()
    }
	
	// MARK: - Private
	
	private func loadLocalHTML() {
		guard let path = Bundle.main.path(forResource: self.fileName, ofType: nil) else { return }
		do {
			let html = try String(contentsOfFile: path)
			self.webView.loadHTMLString(html, baseURL: nil)
		} catch let error {
			print("\(self) Error: \(error)")
		}
	}
	
	// MARK: - Actions
	
	@IBAction private func dismiss() {
		self.dismissOrPopViewController()
	}

	// MARK: -
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
}

extension HTWNamespace where Base: WKWebViewConfiguration {
	
	static var config: WKWebViewConfiguration {
		let javaScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
		
		let script = WKUserScript(source: javaScript,
								  injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
								  forMainFrameOnly: true)
		
		let controller = WKUserContentController()
		controller.addUserScript(script)
		
		let config = WKWebViewConfiguration()
		config.userContentController = controller

		return config
	}
	
}
