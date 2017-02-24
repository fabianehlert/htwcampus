//
//  ScheduleMainVC.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23/02/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class ScheduleMainVC: CollectionViewController {

    init() {
        super.init(layout: UICollectionViewFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Lecture.get(year: "2016", major: "044", group: "71-IK").subscribe(onNext: { lectures in
            print(lectures)
        }, onError: { err in
            print(err)
        })
        .addDisposableTo(self.rx_disposeBag)
    }

}
