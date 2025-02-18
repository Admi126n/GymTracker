//
//  TrainingViewModelTests.swift
//  TrainingViewModelTests
//
//  Created by Adam Tokarski on 18/02/2025.
//

import Testing

@testable import GymTracker

class TrainingViewModelTests {
	
	private var training: Training!
	private var sut: TrainingView.ViewModel!
	
	init() {
		training = Training(startDate: .now)
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
		let exercise = Exercise(name: "Text", sets: [], options: .repetitions)
		let repetitions = 10
		
		sut.addExerciseSet(to: exercise, repetitions: repetitions)
		
		let result = exercise.sets.last
		
		#expect(result != nil)
		#expect(result?.repetitions == repetitions)
	}
	
	@Test func addExerciseSetWithWeightTest() {
		let exercise = Exercise(name: "Text", sets: [], options: .weight)
		let weight = 10.0
		
		sut.addExerciseSet(to: exercise, weight: weight)
		
		let result = exercise.sets.last
		
		#expect(result != nil)
		#expect(result?.weight == weight)
	}
	
	@Test func addExerciseSetWithDistanceTest() {
		let exercise = Exercise(name: "Text", sets: [], options: .distance)
		let distance = 10.0
		
		sut.addExerciseSet(to: exercise, distance: distance)
		
		let result = exercise.sets.last
		
		#expect(result != nil)
		#expect(result?.distance == distance)
	}
}
