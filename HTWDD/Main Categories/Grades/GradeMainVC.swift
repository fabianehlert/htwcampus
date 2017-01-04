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

        Course.get(sNumber: "", password: "").subscribe(onNext: { courses in

            print(courses)

        }, onError: { error in print(error) }).addDisposableTo(self.rx_disposeBag)

    }

}
