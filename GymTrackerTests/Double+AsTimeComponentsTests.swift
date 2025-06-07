//
//  Double+AsTimeComponentsTests.swift
//  GymTrackerTests
//
//  Created by Adam Tokarski on 07/06/2025.
//

import Foundation
import Testing

@testable import GymTracker

struct DoubleAsTimeComponentsTests {
	@Test func doubleWithHoursTest() {
		// 1h, 2min, 5s
		let value: Double = 3600 + 120 + 5
		
		let result = value.asTimeComponents
		
		#expect(result == "1:02:05")
	}
	
	@Test func doubleWithoutHoursTest() {
		// 2min, 5s
		let value: Double = 120 + 5
		
		let result = value.asTimeComponents
		
		#expect(result == "2:05")
	}
}
