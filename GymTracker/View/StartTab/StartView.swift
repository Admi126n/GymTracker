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
	
	@State private var newTraining: TrainingModel?
	@State private var showingStats = false
	
    var body: some View {
		NavigationStack {
			VStack {
				Button("Start training") {
					newTraining = TrainingModel(startDate: .now)
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
					Button("Clear model context", systemImage: "trash") { resetModelContext()
						ExerciseRecordManager.shared.clearData()
					}
					.tint(.red)
				}
#endif
			}
		}
    }
	
	private func resetModelContext() {
		do {
			try modelContext.delete(model: TrainingModel.self)
			try modelContext.delete(model: ExerciseModel.self)
			try modelContext.delete(model: SetModel.self)
		} catch {
			print("Failed to clear model context.")
		}
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: TrainingModel.self, configurations: config)
		return StartView()
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container")
	}
}
