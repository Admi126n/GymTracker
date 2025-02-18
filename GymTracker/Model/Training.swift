//
//  Training.swift
//  GymTracker
//
//  Created by Adam Tokarski on 16/02/2025.
//

import Foundation
import SwiftData

enum TrainingState: Codable {
	case inProgress
	case finished
	case planned
}

@Model
final class Training {
	var name: String?
	var startDate: Date
	var state: TrainingState
	@Relationship(deleteRule: .cascade) var exercises: [Exercise]
	
	init(startDate: Date) {
		self.startDate = startDate
		self.state = .inProgress
		self.exercises = []
		self.name = "New training"
	}
}
