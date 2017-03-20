//
//  GradeMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 30/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit

class GradeMainVC: ViewController {

    let network = Network()

    override func viewDidLoad() {
        super.viewDidLoad()

        let sNumber = ""
        let password = ""

        Course.get(network: self.network, sNumber: sNumber, password: password)
            .map { $0.first }
            .filterNil()
            .subscribe(onNext: { [weak self] course in

                guard let `self` = self else { return }

                Grade.get(network: self.network, sNumber: sNumber, password: password, course: course)
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
