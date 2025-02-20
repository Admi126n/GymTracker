//
//  ExercisesView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 18/02/2025.
//

import SwiftData
import SwiftUI

struct ExercisesView: View {
	
	@Query private var exercises: [ExerciseModel]
	
	@State private var searchText = ""
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(exercises) { exercise in
					Text(exercise.name)
				}
			}
			.searchable(text: $searchText, prompt: "Search for exercise")
		}
    }
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: ExerciseModel.self, configurations: config)
		let exercises = [
			ExerciseModel(name: "Example", mainStat: .weight),
			ExerciseModel(name: "Example", mainStat: .distance),
			ExerciseModel(name: "Example", mainStat: .timeLessIsBetter),
			ExerciseModel(name: "Example", mainStat: .timeMoreIsBetter),
			ExerciseModel(name: "Example", mainStat: .weight),
			ExerciseModel(name: "Example", mainStat: .weight)
		]
		exercises.forEach {
			container.mainContext.insert($0)
		}
		
		return ExercisesView()
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container")
	}
}
