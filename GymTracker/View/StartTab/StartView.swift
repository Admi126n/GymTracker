//
//  StartView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 18/02/2025.
//

import SwiftData
import SwiftUI

struct StartView: View {
	
	@Environment(\.modelContext) var modelContext
	
	@State private var newTraining: Training?
	@State private var showingStats = false
	
    var body: some View {
		NavigationStack {
			VStack {
				Button("Start training") {
					newTraining = Training(startDate: .now)
					modelContext.insert(newTraining!)
				}
			}
			.fullScreenCover(item: $newTraining) { TrainingView(training: $0) }
			.sheet(isPresented: $showingStats) {
				VStack {
					StatisticsMainView()
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Statistics", systemImage: "person.circle") {
						showingStats.toggle()
					}
				}
				
#if DEBUG
				ToolbarItem(placement: .topBarLeading) {
					Button("Clear model context", systemImage: "trash", action: resetModelContext)
						.tint(.red)
				}
#endif
			}
		}
    }
	
	private func resetModelContext() {
		do {
			try modelContext.delete(model: Training.self)
			try modelContext.delete(model: Exercise.self)
			try modelContext.delete(model: ExerciseSet.self)
		} catch {
			print("Failed to clear model context.")
		}
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Training.self, configurations: config)
		return StartView()
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container")
	}
}
