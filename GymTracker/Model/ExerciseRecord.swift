//
//  ExerciseStats.swift
//  GymTracker
//
//  Created by Adam Tokarski on 19/02/2025.
//

import Foundation

struct ExerciseRecord: Codable, Hashable {
	var uuid: String
	var name: String
	var mainStat: ExerciseStatistic
	var record: Double
	var seatHeight: String?
	var optionalStats: [ExerciseStatistic]
	var recordDate: TimeInterval
	
	init(
		uuid: String,
		name: String,
		mainStat: ExerciseStatistic,
		record: Double,
		seatHeight: String?,
		additionalStats: [ExerciseStatistic] = [],
		recordDate: Date
	) {
		self.uuid = uuid
		self.name = name
		self.mainStat = mainStat
		self.record = record
		self.seatHeight = seatHeight
		self.optionalStats = additionalStats
		self.recordDate = recordDate.timeIntervalSince1970
	}
	
	func hasEqualProperties(name: String, mainStat: ExerciseStatistic, optionalStats: [ExerciseStatistic]) -> Bool {
		self.name == name &&
		self.mainStat == mainStat &&
		self.optionalStats == optionalStats
	}
}
