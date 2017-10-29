//
//  OnboardStudygroupViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 12.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardStudygroupViewController: OnboardDetailViewController<ScheduleService.Auth> {

    private lazy var yearTextField = StudygroupTextField()
    private lazy var majorTextField = StudygroupTextField()
    private lazy var groupTextField = StudygroupTextField()

    // MARK: - ViewController lifecycle

    override func initialSetup() {
        self.config = .init(title: Loca.Onboarding.Studygroup.title,
                            description: Loca.Onboarding.Studygroup.body,
                            textFields: [self.yearTextField, self.majorTextField, self.groupTextField],
                            textFieldStackViewAxis: UILayoutConstraintAxis.horizontal,
                            notNowText: Loca.Onboarding.Studygroup.notnow,
                            continueButtonText: Loca.nextStep)

        self.yearTextField.configurationType = .year
        self.majorTextField.configurationType = .major
        self.groupTextField.configurationType = .group

        super.initialSetup()

        // --- Make first text field active ---
        self.yearTextField.becomeFirstResponder()
    }

    // MARK: - Actions

    @objc
    override func continueBoarding() {
        guard
            let y = self.yearTextField.text,
            let m = self.majorTextField.text,
            let g = self.groupTextField.text
        else {
                self.onFinish?(nil)
                return
        }

        let group = ScheduleService.Auth(year: y, major: m, group: g)
        self.onFinish?(group)
    }

    override func shouldReplace(textField: UITextField, newString: String) -> Bool {
        guard
            let f = textField as? StudygroupTextField,
            let config = f.configurationType
        else {
                return super.shouldReplace(textField: textField, newString: newString)
        }

        if newString.count > config.length {
            return false
        }

        return f.isInputValid(newString)
    }

    override func shouldContinue(textField: UITextField) -> Bool {
        if let textField = textField as? StudygroupTextField, textField.isInputFinal() {
            self.jumpToNextField(from: textField)
        }

        let y = yearTextField.isInputFinal()
        let m = majorTextField.isInputFinal()
        let g = groupTextField.isInputFinal()

        return y && m && g
    }

    private func jumpToNextField(from textField: StudygroupTextField) {
        if textField == self.yearTextField {
            self.majorTextField.becomeFirstResponder()
        } else if textField == self.majorTextField {
            self.groupTextField.becomeFirstResponder()
        } else if textField == self.groupTextField {
            self.groupTextField.resignFirstResponder()
        }
    }

}
