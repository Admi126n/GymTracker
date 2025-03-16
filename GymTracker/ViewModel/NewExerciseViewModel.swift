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
		@Published var selectedRecord: ExerciseRecord?
		
		var optionalStatsCases: [ExerciseStatistic] {
			var output: Set<ExerciseStatistic> = []
			
			if mainStat.isTimeReleated {
				output = Set(ExerciseStatistic.allCases.filter { !$0.isTimeReleated })
			} else {
				output = Set(ExerciseStatistic.allCases.filter { $0 != mainStat })
			}
			
			if optionalStats.contains(.speed) {
				output.remove(.duration)
			} else if optionalStats.contains(.duration) {
				output.remove(.speed)
			}
			
			return Array(output).sorted(using: SortDescriptor(\.rawValue))
		}
		
		private func removeStatFromOptionalStats() {
			optionalStats.remove(mainStat)
			
			if mainStat == .speed {
				optionalStats.remove(.duration)
			} else if mainStat == .duration {
				optionalStats.remove(.speed)
			}
		}
	}
}
