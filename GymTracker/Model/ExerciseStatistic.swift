//
//  ExerciseStatistic.swift
//  GymTracker
//
//  Created by Adam Tokarski on 20/02/2025.
//

import Foundation

enum ExerciseStatistic: String, CaseIterable, Codable {
	case weight = "Weight"
	case distance = "Distance"
	case repetitions = "Repetitions"
	case timeMoreIsBetter = "Time - more is better"
	case timeLessIsBetter = "Time - less is better"
	
	var symbol: String {
		switch self {
		case .weight:
			"scalemass"
		case .distance:
			"ruler"
		case .repetitions:
			"repeat"
		case .timeMoreIsBetter:
			"hourglass.tophalf.filled"
		case .timeLessIsBetter:
			"timer"
		}
	}
	
	var unit: String {
		switch self {
		case .weight:
			"kg"
		case .distance:
			"km"
		case .repetitions:
			""
		case .timeMoreIsBetter:
			""
		case .timeLessIsBetter:
			""
		}
	}
}
