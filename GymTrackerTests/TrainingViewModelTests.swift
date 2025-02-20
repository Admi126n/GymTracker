//
//  TrainingViewModelTests.swift
//  TrainingViewModelTests
//
//  Created by Adam Tokarski on 18/02/2025.
//

import Testing

@testable import GymTracker

class TrainingViewModelTests {
	
	private var training: TrainingModel!
	private var sut: TrainingView.ViewModel!
	
	init() {
		training = TrainingModel(startDate: .now)
		sut = TrainingView.ViewModel(training: training)
	}
	
	deinit {
		training = nil
		sut = nil
	}
	
	@Test func addExerciseTest() {
		sut.addExercise()
		
		#expect(training.exercises.count == 1)
	}
	
	@Test func addExerciseSetWithRepetitionsTest() {
		let exercise = ExerciseModel(name: "Test", mainStat: .repetitions)
		let repetitions = 10.0
		
		sut.addExerciseSet(to: exercise, value: repetitions)
		
		let result = exercise.sets.last
		
		#expect(result != nil)
		#expect(result?.mainStat.value == repetitions)
	}
	
	@Test func addExerciseSetWithWeightTest() {
		let exercise = ExerciseModel(name: "Test", mainStat: .weight)
		let weight = 10.0
		
		sut.addExerciseSet(to: exercise, value: weight)
		
		let result = exercise.sets.last
		
		#expect(result != nil)
		#expect(result?.mainStat.value == weight)
	}
	
	@Test func addExerciseSetWithDistanceTest() {
		let exercise = ExerciseModel(name: "Test", mainStat: .distance)
		let distance = 10.0
		
		sut.addExerciseSet(to: exercise, value: distance)
		
		let result = exercise.sets.last
		
		#expect(result != nil)
		#expect(result?.mainStat.value == distance)
	}
}
