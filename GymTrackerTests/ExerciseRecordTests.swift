//
//  ExerciseRecordTests.swift
//  GymTrackerTests
//
//  Created by Adam Tokarski on 07/06/2025.
//

import Foundation
import Testing

@testable import GymTracker

struct ExerciseRecordTests {
	@Test func hasEqualPropertiesWithNoOptionalStatsTest() {
		let name = "test"
		let mainStat = ExerciseStatistic.weight
		let optionalStats: [ExerciseStatistic] = []
		
		let rhs = ExerciseRecord(
			uuid: name,
			name: name,
			mainStat: mainStat,
			record: 100,
			seatHeight: nil,
			additionalStats: optionalStats,
			recordDate: .now)
		
		#expect(rhs.hasEqualProperties(name: name, mainStat: mainStat, optionalStats: optionalStats))
	}
	
	@Test func hasEqualPropertiesWithOptionalStatsTest() {
		let name = "test"
		let mainStat = ExerciseStatistic.weight
		let optionalStats: [ExerciseStatistic] = [.distance]
		
		let rhs = ExerciseRecord(
			uuid: name,
			name: name,
			mainStat: mainStat,
			record: 100,
			seatHeight: nil,
			additionalStats: optionalStats,
			recordDate: .now)
		
		#expect(rhs.hasEqualProperties(name: name, mainStat: mainStat, optionalStats: optionalStats))
	}
	
	@Test func hasEqualPropertiesWithDifferentPropertiesTest() {
		let name = "test"
		let mainStat = ExerciseStatistic.weight
		let optionalStats: [ExerciseStatistic] = [.distance]
		
		let rhs = ExerciseRecord(
			uuid: name,
			name: name,
			mainStat: .speed,
			record: 100,
			seatHeight: nil,
			additionalStats: optionalStats,
			recordDate: .now)
		
		#expect(!rhs.hasEqualProperties(name: name, mainStat: mainStat, optionalStats: optionalStats))
	}
}
