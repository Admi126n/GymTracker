//
//  Collection+best.swift
//  GymTracker
//
//  Created by Adam Tokarski on 20/02/2025.
//

import Foundation

extension Array<ExerciseSetModel> {
	func best() -> Element? {
		self.max()
	}
}
