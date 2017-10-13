//
//  Coordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 13.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

/**
	Objects handling (coordinating) the presentation of ViewControllers need to implement this protocol.
*/
public protocol Coordinator: class {
	/// The array containing any child Coordinators
	var childCoordinators: [Coordinator] { get set }
}

public extension Coordinator {
	/// Add a child coordinator to the parent
	public func addChildCoordinator(_ childCoordinator: Coordinator) {
		self.childCoordinators.append(childCoordinator)
	}

	/// Remove a child coordinator from the parent
	public func removeChildCoordinator(_ childCoordinator: Coordinator) {
		self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
	}
}
