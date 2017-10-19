//
//  TextField.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 19.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class TextField: UITextField {

	override init(frame: CGRect) {
		super.init(frame: frame)
		initialSetup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialSetup()
	}

	func initialSetup() {}

}
