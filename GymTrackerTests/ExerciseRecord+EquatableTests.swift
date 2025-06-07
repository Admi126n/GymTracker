//
//  ExerciseRecordExtensionTests.swift
//  GymTrackerTests
//
//  Created by Adam Tokarski on 07/06/2025.
//

import Foundation
import Testing

@testable import GymTracker

struct ExerciseRecordEquatableTests {
	@Test func checkEqualExercises() {
		let rhs = ExerciseRecord(
			uuid: "1",
			name: "rhs",
			mainStat: .weight,
			record: 100,
			seatHeight: nil,
			recordDate: .now)
		
		let lhs = ExerciseRecord(
			uuid: "1",
			name: "rhs",
			mainStat: .weight,
			record: 100,
			seatHeight: nil,
			recordDate: .now)
		
		#expect(rhs == lhs)
	}
	
	@Test func checkNotEqualExercises() {
		let rhs = ExerciseRecord(
			uuid: "1",
			name: "rhs",
			mainStat: .weight,
			record: 100,
			seatHeight: nil,
			recordDate: .now)
		
		let lhs = ExerciseRecord(
			uuid: "2",
			name: "rhs",
			mainStat: .weight,
			record: 100,
			seatHeight: nil,
			recordDate: .now)
		
		#expect(rhs != lhs)
	}
}
