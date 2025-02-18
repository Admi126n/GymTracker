//
//  Exercise.swift
//  GymTracker
//
//  Created by Adam Tokarski on 16/02/2025.
//

import Foundation
import SwiftData

struct Stats: Codable, OptionSet {
	let rawValue: UInt
	
	static let distance = Stats(rawValue: 1 << 0)
	static let time = Stats(rawValue: 1 << 1)
	static let weight = Stats(rawValue: 1 << 2)
	static let repetitions = Stats(rawValue: 1 << 3)
	static let seatHeight = Stats(rawValue: 1 << 3)
	
	static let distanceAndTime: Stats = [.distance, .time]
}

@Model
final class Exercise {
	var name: String
	var options: Stats
	@Relationship(deleteRule: .cascade) var sets: [ExerciseSet]
	
	init(name: String, sets: [ExerciseSet], options: Stats) {
		self.name = name
		self.sets = sets
		self.options = options
	}
}
