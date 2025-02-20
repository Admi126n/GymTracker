//
//  ExerciseModelTests.swift
//  GymTrackerTests
//
//  Created by Adam Tokarski on 20/02/2025.
//

import Foundation
import Testing

@testable import GymTracker

struct ExerciseModelTests {
	@Test func createExerciseModelFromSavedStatsTest() {
		let uuid = UUID().uuidString
		let name = "Test"
		let mainStat = ExerciseStatistic.weight
		let record = 100.0
		let seatHeight: String? = nil
		let additionalStats = [ExerciseStatistic.distance]
		let recordDate = Date.now
		
		let savedStats = ExerciseStats(uuid: uuid,
									   name: name,
									   mainStat: mainStat,
									   record: record,
									   seatHeight: seatHeight,
									   additionalStats: additionalStats,
									   recordDate: recordDate)
		
		let result = ExerciseModel(savedStats: savedStats)
		
		#expect(result.uuid == uuid)
		#expect(result.name == name)
		#expect(result.mainStat == mainStat)
		#expect(result.additionalStats == additionalStats)
		#expect(result.seatHeight == seatHeight)
		#expect(result.sets.isEmpty)
	}
	
	@Test func addSetTest() {
		let mainStat = ExerciseStatistic.weight
		let value = 100.0
		let exercise = ExerciseModel(name: "Test", mainStat: mainStat)
		
		exercise.addSet(mainValue: value, additionalStats: [:])
		
		#expect(exercise.sets.count == 1)
		#expect(exercise.sets.last!.mainStat.type == mainStat)
		#expect(exercise.sets.last!.mainStat.value == value)
		#expect(exercise.sets.last!.stats.isEmpty)
	}
	
	@Test func getBestMainStatValueTest() {
		let mainStat = ExerciseStatistic.weight
		let value1 = 100.0
		let value2 = 150.0
		let exercise = ExerciseModel(name: "Test", mainStat: mainStat)
		
		exercise.addSet(mainValue: value1, additionalStats: [:])
		exercise.addSet(mainValue: value2, additionalStats: [:])
		
		let result = exercise.getBestMainStatValue()
		
		#expect(result == value2)
	}
	
	@Test func getBestMainStatValueForTimeLessIsBetterTest() {
		let mainStat = ExerciseStatistic.timeLessIsBetter
		let value1 = 100.0
		let value2 = 150.0
		let exercise = ExerciseModel(name: "Test", mainStat: mainStat)
		
		exercise.addSet(mainValue: value1, additionalStats: [:])
		exercise.addSet(mainValue: value2, additionalStats: [:])
		
		let result = exercise.getBestMainStatValue()
		
		#expect(result == value1)
	}
	
	@Test func getBestMainStatValueForEmptySetsTest() {
		let mainStat = ExerciseStatistic.timeLessIsBetter
		let exercise = ExerciseModel(name: "Test", mainStat: mainStat)
		
		let result = exercise.getBestMainStatValue()
		
		#expect(result == 0.0)
	}
}
