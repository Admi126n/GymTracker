//
//  ExerciseSet.swift
//  GymTracker
//
//  Created by Adam Tokarski on 16/02/2025.
//

import Foundation
import SwiftData

@Model
final class ExerciseSet {
	var repetitions: Int?
	var weight: Double?
	var time: TimeInterval?
	var distance: Double?
	
	init(
		repetitions: Int? = nil,
		weight: Double? = nil,
		time: TimeInterval? = nil,
		distance: Double? = nil
	) {
		self.repetitions = repetitions
		self.weight = weight
		self.time = time
		self.distance = distance
	}
	
	func desc() -> String {
		"\(repetitions ?? 0), \(weight ?? 0), \(time ?? 0), \(distance ?? 0)"
	}
}
