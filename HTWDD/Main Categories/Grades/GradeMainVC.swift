//
//  GradeMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit
import RxOptional

class GradeMainVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let sNumber = ""
        let password = ""

        Course.get(sNumber: sNumber, password: password)
            .map { $0.first }
            .filterNil()
            .subscribe(onNext: { course in

                Grade.get(sNumber: sNumber, password: password, course: course)
                    .map(Grade.groupAndOrderBySemester)
                    .subscribe(onNext: { grades in

                        print(grades)

                    }, onError: {
                        error in
                        print(error)
                    }).addDisposableTo(self.rx_disposeBag)

            }, onError: { error in

                print(error)

            }).addDisposableTo(self.rx_disposeBag)

    }

}
