//
//  ExerciseStatistic.swift
//  GymTracker
//
//  Created by Adam Tokarski on 20/02/2025.
//

import Foundation

enum ExerciseStatistic: String, CaseIterable, Codable {
	case weight
	case distance
	case repetitions
	case timeMoreIsBetter
	case timeLessIsBetter
	
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
}
