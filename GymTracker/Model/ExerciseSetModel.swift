//
//  ExerciseSetModel.swift
//  GymTracker
//
//  Created by Adam Tokarski on 16/02/2025.
//

import Foundation
import SwiftData

@Model
final class ExerciseSetModel {
	var mainStat: MainStatistic
	var stats: [ExerciseStatistic: Double]
	
	init(mainStat: MainStatistic, stats: [ExerciseStatistic: Double] = [:]) {
		self.mainStat = mainStat
		self.stats = stats
	}
	
	var description: String {
		"\(mainStat.type): \(mainStat.value)"
	}
}

extension ExerciseSetModel: Comparable {
	static func < (lhs: ExerciseSetModel, rhs: ExerciseSetModel) -> Bool {
		if lhs.mainStat.type == .timeLessIsBetter {
			return lhs.mainStat.value > rhs.mainStat.value
		} else {
			return lhs.mainStat.value < rhs.mainStat.value
		}
	}
}
