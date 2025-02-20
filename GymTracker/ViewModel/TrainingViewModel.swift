//
//  TrainingViewModel.swift
//  GymTracker
//
//  Created by Adam Tokarski on 18/02/2025.
//

import Foundation

extension TrainingView {
	@Observable
	class ViewModel {
		
		var training: TrainingModel

		init(training: TrainingModel) {
			self.training = training
		}
		
		func addExercise() {
			let exercise = ExerciseModel(name: "New", mainStat: .weight)
			training.exercises.append(exercise)
		}

		func addExerciseSet(
			to exercise: ExerciseModel,
			value: Double,
			additionalStats: [ExerciseStatistic: Double] = [:]
		) {
			exercise.addSet(mainValue: value, additionalStats: additionalStats)
		}
	}
}
