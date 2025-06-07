//
//  ExerciseStatisticTests.swift
//  GymTrackerTests
//
//  Created by Adam Tokarski on 07/06/2025.
//

import Foundation
import Testing

@testable import GymTracker

struct ExerciseStatisticTests {
	@Test("Check if symbol is correct",
		  arguments: zip(ExerciseStatistic.allCases, ["scalemass", "ruler", "repeat", "hourglass.tophalf.filled", "timer"]))
	func symbolTest(testCase: ExerciseStatistic, expectedSymbol: String) {
		let symbol = testCase.symbol
		
		#expect(symbol == expectedSymbol)
	}
	
	@Test("Check if unit is correct for non unit cases",
		  arguments: [ExerciseStatistic.repetitions, .duration, .speed])
	func unitTestForNonUnitCases(testCase: ExerciseStatistic) {
		let unit = testCase.unit
		
		#expect(unit == "")
	}
	
	@Test("Check if unit is correct for unit cases",
		  arguments: zip([ExerciseStatistic.weight, .distance], ["kg", "km"]))
	func unitTestForUnitCases(testCase: ExerciseStatistic, expectedUnit: String) {
		let unit = testCase.unit
		
		#expect(unit == expectedUnit)
	}
	
	@Test("CheckIsTimeRelatedForNonTimeRelatedCases",
		  arguments: [ExerciseStatistic.weight, .distance, .repetitions])
	func isTimeRelatedTestForNonTimeRelatedCases(testCase: ExerciseStatistic) {
		#expect(testCase.isTimeReleated == false)
	}
	
	@Test("CheckIsTimeRelatedForTimeRelatedCases",
		  arguments: [ExerciseStatistic.duration, .speed])
	func isTimeRelatedTestForTimeRelatedCases(testCase: ExerciseStatistic) {
		#expect(testCase.isTimeReleated == true)
	}
}
