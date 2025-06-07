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
	@Test func initWithNameAndStatsTest() {
		let name = "New exercise"
		let date = Date.now
		let mainStat = ExerciseStatistic.weight
		let expectedAdditionalStats: [ExerciseStatistic] = [.distance, .repetitions]
		let additionalStats = expectedAdditionalStats + [mainStat]
		
		let sut = ExerciseModel(name: name, mainStat: mainStat, optionalStats: additionalStats, startDate: date)
		
		#expect(sut.name == name)
		#expect(sut.timestamp == date.timeIntervalSince1970)
		#expect(sut.mainStat == mainStat)
		#expect(sut.seatHeight == nil)
		#expect(sut.optionalStats == expectedAdditionalStats)
	}
	
	@Test func createExerciseModelFromSavedStatsTest() {
		let uuid = UUID().uuidString
		let name = "Test"
		let mainStat = ExerciseStatistic.weight
		let record = 100.0
		let seatHeight: String? = nil
		let additionalStats = [ExerciseStatistic.distance]
		let recordDate = Date.now
		
		let exericseRecord = ExerciseRecord(uuid: uuid,
									   name: name,
									   mainStat: mainStat,
									   record: record,
									   seatHeight: seatHeight,
									   additionalStats: additionalStats,
									   recordDate: recordDate)
		
		let result = ExerciseModel(exerciseRecord: exericseRecord)
		
		#expect(result.uuid == uuid)
		#expect(result.name == name)
		#expect(result.mainStat == mainStat)
		#expect(result.optionalStats == additionalStats)
		#expect(result.seatHeight == seatHeight)
		#expect(result.sets.isEmpty)
	}
	
	@Test func addSetTest() {
		let mainStat = ExerciseStatistic.weight
		let value = 100.0
		let exercise = ExerciseModel(name: "Test", mainStat: mainStat)
		
		exercise.addSet(stats: [mainStat: value])
		
		#expect(exercise.sets.count == 1)
		#expect(exercise.sets.last!.mainStat == mainStat)
		#expect(exercise.sets.last!.stats[mainStat] == value)
		#expect(!exercise.sets.last!.stats.isEmpty)
	}
	
	@Test func getBestMainStatValueTest() {
		let mainStat = ExerciseStatistic.weight
		let value1 = 100.0
		let value2 = 150.0
		let exercise = ExerciseModel(name: "Test", mainStat: mainStat)
		
		exercise.addSet(stats: [mainStat: value1])
		exercise.addSet(stats: [mainStat: value2])
		
		let result = exercise.getBestValue()
		
		#expect(result == value2)
	}
	
	@Test func getBestMainStatValueForTimeLessIsBetterTest() {
		let mainStat = ExerciseStatistic.speed
		let value1 = 100.0
		let value2 = 150.0
		let exercise = ExerciseModel(name: "Test", mainStat: mainStat)
		
		exercise.addSet(stats: [mainStat: value1])
		exercise.addSet(stats: [mainStat: value2])
		
		let result = exercise.getBestValue()
		
		#expect(result == value1)
	}
	
	@Test func getBestMainStatValueForEmptySetsTest() {
		let mainStat = ExerciseStatistic.speed
		let exercise = ExerciseModel(name: "Test", mainStat: mainStat)
		
		let result = exercise.getBestValue()
		
		#expect(result == 0.0)
	}
	
	@Test func getAllStatsTest() {
		let mainStat = ExerciseStatistic.weight
		let optionalStat = ExerciseStatistic.repetitions
		
		let exercise = ExerciseModel(name: "Test", mainStat: mainStat, optionalStats: [optionalStat])
		
		#expect(exercise.allStats == [optionalStat, mainStat])
	}
	
	@Test func setSeatHeightTest() {
		let seatHeight = "10.0"
		let exercise = ExerciseModel(name: "Test", mainStat: .weight)
		
		exercise.setSeatHeight(seatHeight)
		
		#expect(exercise.seatHeight == seatHeight)
		
		exercise.setSeatHeight("")
		
		#expect(exercise.seatHeight == nil)
	}
	
	@Test func removeExistingSetTest() {
		let exercise = ExerciseModel(name: "Test", mainStat: .weight)
		exercise.addSet(stats: [.weight: 100])
		
		#expect(!exercise.sets.isEmpty)
		
		let set = exercise.sets.last!
		exercise.remove(set: set)
		
		#expect(exercise.sets.isEmpty)
	}
	
	@Test func removeNonExistingSetTest() {
		let exercise = ExerciseModel(name: "Test", mainStat: .weight)
		let set = SetModel(mainStat: .weight, stats: [.weight: 100])
		
		#expect(exercise.sets.isEmpty)
		
		exercise.remove(set: set)
		
		#expect(exercise.sets.isEmpty)
	}
}
