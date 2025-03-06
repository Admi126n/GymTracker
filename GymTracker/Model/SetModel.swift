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
		self.stats = stats
		self.timestamp = timestamp.timeIntervalSince1970
	}
	
	var mainStatValue: Double {
		stats[mainStat] ?? 0
	}
	
	var description: String {
		"Main stat: \(mainStat) \(mainStatValue)\(allStatsDescription)"
	}
	
	private var allStatsDescription: String {
		var output = ""
		
		for stat in stats.filter({ $0.key != mainStat }) {
			output += "\n\(stat.key): \(stat.value)"
		}
		
		return output
	}
}

extension SetModel: Comparable {
	static func < (lhs: SetModel, rhs: SetModel) -> Bool {
		if lhs.mainStat == .timeLessIsBetter {
			return lhs.mainStatValue > rhs.mainStatValue
		} else {
			return lhs.mainStatValue < rhs.mainStatValue
		}
	}
}
