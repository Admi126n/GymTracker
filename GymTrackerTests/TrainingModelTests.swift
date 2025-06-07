//
//  TrainingModelTests.swift
//  GymTrackerTests
//
//  Created by Adam Tokarski on 27/02/2025.
//

import Foundation
import Testing

@testable import GymTracker

struct TrainingModelTests {
	@Test func initWithStartDateTest() {
		let date = Date.now
		
		let sut = TrainingModel(startDate: date)
		
		#expect(sut.startDate == date.timeIntervalSince1970)
		#expect(sut.endDate == nil)
		#expect(sut.state == .inProgress)
		#expect(sut.exercises.isEmpty)
	}
	
	@Test func initWithNameTest() {
		let name = "New training"
		let date = Date.now
		
		let sut = TrainingModel(name: name, startDate: date)
		
		#expect(sut.name == name)
		#expect(sut.startDate == date.timeIntervalSince1970)
		#expect(sut.endDate == nil)
		#expect(sut.state == .inProgress)
		#expect(sut.exercises.isEmpty)
	}
	
	@Test func finishTrainingTest() {
		let date = Date.now
		let sut = TrainingModel()
		
		sut.finishTraining(endDate: date)
		
		#expect(sut.state == .finished)
		#expect(sut.endDate == date.timeIntervalSince1970)
	}
	
	@Test func testExercisesOrder() {
		let exercise1 = ExerciseModel(name: "Exercise 1", mainStat: .weight)
		let exercise2 = ExerciseModel(name: "Exercise 2", mainStat: .weight)
		let exercise3 = ExerciseModel(name: "Exercise 3", mainStat: .weight)
		let sut = TrainingModel()
		
		sut.addExercise(exercise1)
		sut.addExercise(exercise2)
		sut.addExercise(exercise3)
		
		#expect(sut.exercises[0] == exercise1)
		#expect(sut.exercises[1] == exercise2)
		#expect(sut.exercises[2] == exercise3)
	}
	
	@Test func removeExistingExerciseTest() {
		let exercise = ExerciseModel(name: "Exercise 1", mainStat: .weight)
		let sut = TrainingModel()
		
		sut.addExercise(exercise)
		
		#expect(!sut.exercises.isEmpty)
		#expect(sut.exercises.last == exercise)
		
		sut.remove(exercise: exercise)
		
		#expect(sut.exercises.isEmpty)
	}
	
	@Test func removeNotExistingExerciseTest() {
		let exercise = ExerciseModel(name: "Exercise 1", mainStat: .weight)
		let sut = TrainingModel()
		
		#expect(sut.exercises.isEmpty)
		
		sut.remove(exercise: exercise)
		
		#expect(sut.exercises.isEmpty)
	}
}
