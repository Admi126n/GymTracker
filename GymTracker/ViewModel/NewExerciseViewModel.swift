//
//  NewExerciseViewModel.swift
//  GymTracker
//
//  Created by Adam Tokarski on 06/03/2025.
//

import SwiftUI

extension NewExerciseView {
	class ViewModel: ObservableObject {
		
		@Published var name = ""
		@Published var mainStat: ExerciseStatistic = .weight {
			didSet {
				removeStatFromOptionalStats()
			}
		}
		@Published var optionalStats: Set<ExerciseStatistic> = []
		
		var optionalStatsCases: [ExerciseStatistic] {
			var output: Set<ExerciseStatistic> = []
			
			switch mainStat {
			case .timeMoreIsBetter, .timeLessIsBetter:
				output = Set(ExerciseStatistic.allCases.filter { $0 != .timeMoreIsBetter && $0 != .timeLessIsBetter})
			default:
				output = Set(ExerciseStatistic.allCases.filter { $0 != mainStat })
			}
			
			if optionalStats.contains(.timeLessIsBetter) {
				output.remove(.timeMoreIsBetter)
			} else if optionalStats.contains(.timeMoreIsBetter) {
				output.remove(.timeLessIsBetter)
			}
			
			return Array(output).sorted(using: SortDescriptor(\.rawValue))
		}
		
		private func removeStatFromOptionalStats() {
			optionalStats.remove(mainStat)
			
			if mainStat == .timeLessIsBetter {
				optionalStats.remove(.timeMoreIsBetter)
			} else if mainStat == .timeMoreIsBetter {
				optionalStats.remove(.timeLessIsBetter)
			}
		}
	}
}
