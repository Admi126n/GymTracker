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
	private(set) var uuid: String
	private(set) var name: String
	private(set) var mainStat: ExerciseStatistic
	private(set) var optionalStats: [ExerciseStatistic]
	private(set) var seatHeight: String?
	private(set) var timestamp: TimeInterval
	
	@Relationship(deleteRule: .cascade)
	private var setsPersistent: [SetModel] = []
	
	var sets: [SetModel] {
		setsPersistent.sorted(using: KeyPathComparator(\.timestamp))
	}
	
	var allStats: [ExerciseStatistic] {
		optionalStats + [mainStat]
	}
	
	init(name: String, mainStat: ExerciseStatistic, optionalStats: [ExerciseStatistic] = [], startDate: Date = .now) {
		self.uuid = UUID().uuidString
		self.name = name
		self.mainStat = mainStat
		self.optionalStats = optionalStats.filter { $0 != mainStat }
		self.timestamp = startDate.timeIntervalSince1970
	}
	
	init(exerciseRecord: ExerciseRecord, startDate: Date = .now) {
		self.uuid = exerciseRecord.uuid
		self.name = exerciseRecord.name
		self.mainStat = exerciseRecord.mainStat
		self.optionalStats = exerciseRecord.optionalStats
		self.seatHeight = exerciseRecord.seatHeight
		self.timestamp = startDate.timeIntervalSince1970
	}
	
	func addSet(stats: [ExerciseStatistic: Double]) {
		let set = SetModel(mainStat: mainStat, stats: stats)
		
		setsPersistent.append(set)
	}
	
	func getBestValue() -> Double {
		setsPersistent.best()?.mainStatValue ?? 0
	}
	
	func setSeatHeight(_ value: String) {
		if value.isEmpty {
			seatHeight = nil
		} else {
			seatHeight = value
		}
	}
}
