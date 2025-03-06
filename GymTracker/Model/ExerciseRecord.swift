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
	
	init() {
		uuid = UUID().uuidString
		name = ""
		mainStat = .weight
		record = 0
		seatHeight = nil
		optionalStats = []
		recordDate = Date.now.timeIntervalSince1970
	}
	
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

extension ExerciseRecord: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.uuid == rhs.uuid
	}
}

class ExerciseRecordManager {
	static let shared = ExerciseRecordManager()
	
	private var fileURL: URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0].appendingPathComponent("ExerciseStats.json")
	}
	
	private func saveStats(_ stats: [ExerciseRecord]) {
		do {
			let data = try JSONEncoder().encode(stats)
			try data.write(to: fileURL, options: .atomic)
		} catch {
			print("Failed to save exercise stats: \(error)")
		}
	}
	
	func loadStats() -> [ExerciseRecord] {
		do {
			let data = try Data(contentsOf: fileURL)
			return try JSONDecoder().decode([ExerciseRecord].self, from: data)
		} catch {
			print("Failed to load exercise stats: \(error)")
			return []
		}
	}
	
	func clearData() {
		try? FileManager.default.removeItem(atPath: fileURL.path())
	}
	
	func addOrUpdateStat(_ newStat: ExerciseRecord) {
		var stats = loadStats()
		
		if let index = stats.firstIndex(of: newStat) {
			stats[index] = newStat
		} else {
			stats.append(newStat)
		}
		
		saveStats(stats)
	}
	
	func addOrUpdateStats(_ newStats: [ExerciseModel]) {
		newStats.forEach(addOrUpdateStat)
	}
	
	func addOrUpdateStat(_ newStat: ExerciseModel) {
		var stats = loadStats()
		
		if let index = stats.firstIndex(where: {
			$0.uuid == newStat.uuid &&
			$0.mainStat == newStat.mainStat &&
			$0.optionalStats == newStat.optionalStats}
		) {
			if stats[index].record < newStat.getBestValue() {
				let new = ExerciseRecord(uuid: newStat.uuid,
										name: newStat.name,
										mainStat: newStat.mainStat,
										record: newStat.getBestValue(),
										seatHeight: newStat.seatHeight,
										additionalStats: newStat.optionalStats,
										recordDate: .now)
				stats[index] = new
			}
		} else {
			let new = ExerciseRecord(uuid: newStat.uuid,
									name: newStat.name,
									mainStat: newStat.mainStat,
									record: newStat.getBestValue(),
									seatHeight: newStat.seatHeight,
									additionalStats: newStat.optionalStats,
									recordDate: .now)
			stats.append(new)
		}
		
		saveStats(stats)
	}
	
	func getBestForExerciseWith(uuid: String) -> Double {
		let loaded = loadStats()
		
		return loaded.first { $0.uuid == uuid }?.record ?? 0
	}
}
