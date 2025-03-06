//
//  TrainingsView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 18/02/2025.
//

import SwiftData
import SwiftUI

struct TrainingsView: View {
	
	@Query private var trainings: [TrainingModel]
	
	@State private var searchText = ""
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(trainings) { training in
					Text(training.name)
				}
			}
			.searchable(text: $searchText, prompt: "Search for training")
		}
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: TrainingModel.self, configurations: config)
		let trainings = [
			TrainingModel(),
			TrainingModel(),
			TrainingModel(),
			TrainingModel(),
			TrainingModel()
		]
		trainings.forEach {
			container.mainContext.insert($0)
		}
		
		return TrainingsView()
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container")
	}
}
