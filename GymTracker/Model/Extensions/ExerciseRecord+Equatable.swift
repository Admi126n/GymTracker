//
//  ExerciseRecord+Equatable.swift
//  GymTracker
//
//  Created by Adam Tokarski on 08/03/2025.
//

import Foundation

extension ExerciseRecord: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.uuid == rhs.uuid
	}
}
