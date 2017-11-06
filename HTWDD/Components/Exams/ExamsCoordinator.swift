//
//  ExamsCoordinator.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ExamsCoordinator: Coordinator {
    
    var rootViewController: UIViewController {
        return self.examController.inNavigationController()
    }
    
    var childCoordinators = [Coordinator]()
    
    private lazy var examController = ExamMainVC(context: self.context)
    
    var auth: ScheduleService.Auth? {
        didSet {
            self.examController.auth = self.auth
        }
    }
    
    let context: HasExams
    init(context: HasExams) {
        self.context = context
    }
    
}
