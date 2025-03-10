//
//  ExerciseSetModel.swift
//  GymTracker
//
//  Created by Adam Tokarski on 16/02/2025.
//

import Foundation
import SwiftData

@Model
final class SetModel {
	var mainStat: ExerciseStatistic
	var stats: [ExerciseStatistic: Double]
	var timestamp: TimeInterval
	
	init(mainStat: ExerciseStatistic, stats: [ExerciseStatistic: Double], timestamp: Date = .now) {
		self.mainStat = mainStat
		self.timestamp = timestamp.timeIntervalSince1970
		
		var tmp = stats
		tmp[.repetitions] = tmp[.repetitions]?.rounded()
		self.stats = tmp
	}
	
	var mainStatValue: Double {
		stats[mainStat] ?? 0
	}
	
	var description: String {
		stats.map { "\($0.key): \(String(format: "%g", $0.value)) \($0.key.unit)" }.joined(separator: "\n")
	}
}
