//
//  Exercise.swift
//  GymTracker
//
//  Created by Adam Tokarski on 16/02/2025.
//

import Foundation
import SwiftData

@Model
final class ExerciseModel {
	var uuid: String
	var name: String = ""
	var mainStat: ExerciseStatistic
	var additionalStats: [ExerciseStatistic] = []
	var seatHeight: String?
	var startDate: Date
	@Relationship(deleteRule: .cascade) private(set) var sets: [ExerciseSetModel] = []
	
	init(name: String, mainStat: ExerciseStatistic, additionalStats: [ExerciseStatistic] = []) {
		self.uuid = UUID().uuidString
		self.name = name
		self.mainStat = mainStat
		self.additionalStats = additionalStats
		self.startDate = .now
	}
	
	init(savedStats: ExerciseStats, startDate: Date = .now) {
		self.uuid = savedStats.uuid
		self.name = savedStats.name
		self.mainStat = savedStats.mainStat
		self.additionalStats = savedStats.additionalStats
		self.startDate = startDate
	}
	
	func addSet(mainValue: Double, additionalStats: [ExerciseStatistic: Double]) {
		let set = ExerciseSetModel(mainStat: MainStatistic(type: mainStat, value: mainValue), stats: additionalStats)
		
		sets.append(set)
	}
	
	func addSet(stats: [ExerciseStatistic: Double]) {
		var additionalStats = stats
		additionalStats[mainStat] = nil
		
		let set = ExerciseSetModel(
			mainStat: MainStatistic(type: mainStat, value: stats[mainStat] ?? 0),
			stats: additionalStats)
		sets.append(set)
	}
	
	func getBestMainStatValue() -> Double {
		sets.best()?.mainStat.value ?? 0
	}
}
