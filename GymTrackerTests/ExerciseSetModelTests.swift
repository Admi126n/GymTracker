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
			SetModel(mainStat: .weight, stats: [.weight: 100]),
			SetModel(mainStat: .weight, stats: [.weight: 110]),
			SetModel(mainStat: .weight, stats: [.weight: 90]),
			SetModel(mainStat: .weight, stats: [.weight: 101])
		]
		
		let result = sets.best()
		
		#expect(result != nil)
		#expect(result!.mainStatValue == 110)
	}
	
	@Test func getMaxSetForTimeLessIsBetterTest() {
		let sets = [
			SetModel(mainStat: .speed, stats: [.speed: 100]),
			SetModel(mainStat: .speed, stats: [.speed: 110]),
			SetModel(mainStat: .speed, stats: [.speed: 90]),
			SetModel(mainStat: .speed, stats: [.speed: 101])
		]
		
		let result = sets.best()
		
		#expect(result != nil)
		#expect(result!.mainStatValue == 90)
	}
	
	@Test func getMainStatValueForMissingMainStat() {
		let set = SetModel(mainStat: .weight, stats: [.weight: 100])
		set.stats = [:]
	
		#expect(set.mainStatValue == 0)
	}
}
