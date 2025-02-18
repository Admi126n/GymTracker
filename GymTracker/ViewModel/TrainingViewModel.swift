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
		
		var training: Training

		init(training: Training) {
			self.training = training
		}
		
		func addExercise() {
			let exercise = Exercise(name: "New", sets: [], options: .repetitions)
			training.exercises.append(exercise)
		}

		func addExerciseSet(
			to exercise: Exercise,
			repetitions: Int? = nil,
			weight: Double? = nil,
			time: TimeInterval? = nil,
			distance: Double? = nil
		) {
			let exerciseSet = ExerciseSet(repetitions: repetitions, weight: weight, time: time, distance: distance)
			exercise.sets.append(exerciseSet)
		}
	}
}
