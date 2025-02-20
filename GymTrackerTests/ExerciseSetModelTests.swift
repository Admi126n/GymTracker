//
//  ExerciseSetModelTests.swift
//  GymTrackerTests
//
//  Created by Adam Tokarski on 20/02/2025.
//

import Foundation
import Testing

@testable import GymTracker

struct ExerciseSetModelTests {
	@Test func getMaxSetTest() {
		let sets = [
			ExerciseSetModel(mainStat: .init(type: .weight, value: 100)),
			ExerciseSetModel(mainStat: .init(type: .weight, value: 110)),
			ExerciseSetModel(mainStat: .init(type: .weight, value: 90)),
			ExerciseSetModel(mainStat: .init(type: .weight, value: 101))
		]
		
		let result = sets.best()
		
		#expect(result != nil)
		#expect(result!.mainStat.value == 110)
	}
	
	@Test func getMaxSetForTimeLessIsBetterTest() {
		let sets = [
			ExerciseSetModel(mainStat: .init(type: .timeLessIsBetter, value: 100)),
			ExerciseSetModel(mainStat: .init(type: .timeLessIsBetter, value: 110)),
			ExerciseSetModel(mainStat: .init(type: .timeLessIsBetter, value: 90)),
			ExerciseSetModel(mainStat: .init(type: .timeLessIsBetter, value: 101))
		]
		
		let result = sets.best()
		
		#expect(result != nil)
		#expect(result!.mainStat.value == 90)
	}
}
