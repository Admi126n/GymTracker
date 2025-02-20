//
//  ExerciseStats.swift
//  GymTracker
//
//  Created by Adam Tokarski on 19/02/2025.
//

import Foundation

struct ExerciseStats: Codable, Hashable {
	let uuid: String
	let name: String
	let mainStat: ExerciseStatistic
	let record: Double
	let seatHeight: String?
	let additionalStats: [ExerciseStatistic]
	let recordDate: Date
	
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
		self.additionalStats = additionalStats
		self.recordDate = recordDate
	}
}

extension ExerciseStats: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.uuid == rhs.uuid
	}
}

class ExerciseStatsManager {
	static let shared = ExerciseStatsManager()
	
	private var fileURL: URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0].appendingPathComponent("ExerciseStats.json")
	}
	
	private func saveStats(_ stats: [ExerciseStats]) {
		do {
			let data = try JSONEncoder().encode(stats)
			try data.write(to: fileURL, options: .atomic)
		} catch {
			print("Failed to save exercise stats: \(error)")
		}
	}
	
	func loadStats() -> [ExerciseStats] {
		do {
			let data = try Data(contentsOf: fileURL)
			return try JSONDecoder().decode([ExerciseStats].self, from: data)
		} catch {
			print("Failed to load exercise stats: \(error)")
			return []
		}
	}
	
	func clearData() {
		try? FileManager.default.removeItem(atPath: fileURL.path())
	}
	
	func addOrUpdateStat(_ newStat: ExerciseStats) {
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
			$0.additionalStats == newStat.additionalStats}
		) {
			if stats[index].record < newStat.getBestMainStatValue() {
				let new = ExerciseStats(uuid: newStat.uuid,
										name: newStat.name,
										mainStat: newStat.mainStat,
										record: newStat.getBestMainStatValue(),
										seatHeight: newStat.seatHeight,
										additionalStats: newStat.additionalStats,
										recordDate: .now)
				stats[index] = new
			}
		} else {
			let new = ExerciseStats(uuid: newStat.uuid,
									name: newStat.name,
									mainStat: newStat.mainStat,
									record: newStat.getBestMainStatValue(),
									seatHeight: newStat.seatHeight,
									additionalStats: newStat.additionalStats,
									recordDate: .now)
			stats.append(new)
		}
		
		saveStats(stats)
	}
}
