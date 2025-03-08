//
//  ExerciseRecordManager.swift
//  GymTracker
//
//  Created by Adam Tokarski on 08/03/2025.
//

import Foundation

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
	
#warning("Need to check one of the uuid of name + mainStat + optionalStats")
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
