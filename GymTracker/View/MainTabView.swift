//
//  MainTabView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 18/02/2025.
//

#if DEBUG
import SwiftData
#endif

import SwiftUI

struct MainTabView: View {
	
	@State private var selection = 1
	
	var body: some View {
		TabView(selection: $selection) {
			Tab("ExerciseModels", systemImage: "figure.strengthtraining.traditional", value: 0) {
				ExercisesView()
			}
			
			Tab("Start", systemImage: "figure.mixed.cardio", value: 1) {
				StartView()
			}
			
			Tab("Trainings", systemImage: "trophy", value: 2) {
				TrainingsView()
			}
		}
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: TrainingModel.self, configurations: config)
		return MainTabView()
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container")
	}
}
