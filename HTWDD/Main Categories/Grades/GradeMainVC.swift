//
//  GradeMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit

class GradeMainVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let sNumber = ""
        let password = ""
        
        Course.get(sNumber: sNumber, password: password).subscribe(onNext: { courses in

            guard let c = courses.first else {
                return
            }
            Grade.get(sNumber: sNumber, password: password, course: c).subscribe(onNext: { grades in
                
                print(grades)
                
            }, onError: { error in print(error) }).addDisposableTo(self.rx_disposeBag)

        }, onError: { error in print(error) }).addDisposableTo(self.rx_disposeBag)

    }

}
