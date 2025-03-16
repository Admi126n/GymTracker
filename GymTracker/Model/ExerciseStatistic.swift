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
	case duration = "Duration"
	case speed = "Speed"
	
	var symbol: String {
		switch self {
		case .weight:
			"scalemass"
		case .distance:
			"ruler"
		case .repetitions:
			"repeat"
		case .duration:
			"hourglass.tophalf.filled"
		case .speed:
			"timer"
		}
	}
	
	var unit: String {
		switch self {
		case .weight:
			"kg"
		case .distance:
			"km"
		default:
			""
		}
	}
	
	var isTimeReleated: Bool {
		switch self {
		case .duration, .speed:
			return true
		default:
			return false
		}
	}
}
