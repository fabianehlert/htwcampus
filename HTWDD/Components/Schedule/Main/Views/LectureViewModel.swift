//
//  LectureViewModel.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 24.09.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

extension Lecture: Identifiable {}

struct LectureViewModel: ViewModel {
    private let model: Lecture

    var title: String {
        return model.name
    }

    var subtitle: String {
        return model.type
    }

	var room: String? {
		return model.rooms.first
	}

    var start: String {
        return model.begin.localizedDescription
    }

    var end: String {
        return model.end.localizedDescription
    }

    init(model: Lecture) {
        self.model = model
    }
}
