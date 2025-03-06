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
	
	private(set) var name: String
	private(set) var startDate: TimeInterval
	private(set) var endDate: TimeInterval?
	private(set) var state: TrainingState
	
	@Relationship(deleteRule: .cascade)
	private var exercisesPersistent: [ExerciseModel] = []
	
	var exercises: [ExerciseModel] {
		exercisesPersistent.sorted(using: KeyPathComparator(\.timestamp))
	}
	
	init(startDate: Date = .now) {
		self.name = "Training on \(Self.dateFormatter.string(from: .now))"
		self.startDate = startDate.timeIntervalSince1970
		self.state = .inProgress
	}
	
	init(name: String, startDate: Date = .now) {
		self.name = name
		self.startDate = startDate.timeIntervalSince1970
		self.state = .inProgress
	}
	
	func finishTraining(endDate: Date = .now) {
		state = .finished
		self.endDate = endDate.timeIntervalSince1970
	}
	
	func addExercise(_ exercise: ExerciseModel) {
		exercisesPersistent.append(exercise)
	}
}
