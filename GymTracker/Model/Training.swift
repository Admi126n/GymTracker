//
//  TrainingModel.swift
//  GymTracker
//
//  Created by Adam Tokarski on 16/02/2025.
//

import Foundation
import SwiftData

@Model
final class TrainingModel {
	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		
		return formatter
	}()
	
	var name: String
	var startDate: Date
	var endDate: Date?
	var state: TrainingState
	@Relationship(deleteRule: .cascade) var exercises: [ExerciseModel] = []
	
	init(startDate: Date = .now) {
		self.name = "Training on \(Self.dateFormatter.string(from: .now))"
		self.startDate = .now
		self.state = .inProgress
	}
	
	init(name: String) {
		self.name = name
		self.startDate = .now
		self.state = .inProgress
	}
	
	func finishTraining() {
		state = .finished
		endDate = .now
	}
}
