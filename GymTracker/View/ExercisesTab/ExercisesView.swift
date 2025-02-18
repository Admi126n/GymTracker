//
//  ExercisesView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 18/02/2025.
//

import SwiftData
import SwiftUI

struct ExercisesView: View {
	
	@Query private var exercises: [Exercise]
	
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
		let container = try ModelContainer(for: Exercise.self, configurations: config)
		let exercises = [
			Exercise(name: "Example", sets: [], options: []),
			Exercise(name: "Example", sets: [], options: []),
			Exercise(name: "Example", sets: [], options: []),
			Exercise(name: "Example", sets: [], options: []),
			Exercise(name: "Example", sets: [], options: [])
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
