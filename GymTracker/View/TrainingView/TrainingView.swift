//
//  TrainingView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 18/02/2025.
//

import SwiftData
import SwiftUI

struct TrainingView: View {
	
	@Bindable var training: Training
	
	@Environment(\.dismiss) var dismiss
	
	@State private var viewModel: ViewModel
	
	var body: some View {
		ZStack {
			Color.teal
				.ignoresSafeArea(.all)
			
			VStack {
				Text(training.name ?? "Unknown")
				
				Button("End training", role: .destructive) {
					dismiss()
				}
				.buttonStyle(.bordered)
				
				ForEach(training.exercises) { exercise in
					ExerciseView(showTextField: training.exercises.last == exercise, exercise: exercise, viewModel: viewModel)
				}
				
				Spacer()
				
				Button("Next exercise") {
					viewModel.addExercise()
				}
				.buttonStyle(.borderedProminent)
			}
			.containerRelativeFrame([.horizontal], alignment: .top)
		}
	}
	
	init(training: Training) {
		self.training = training
		self._viewModel = State(initialValue: ViewModel(training: training))
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Training.self, configurations: config)
		let training = Training(startDate: .now)
		return TrainingView(training: training)
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container")
	}
}

struct ExerciseView: View {
	
	let showTextField: Bool
	
	@Bindable var exercise: Exercise
	
	@State var noSeries = 0
	@State var viewModel: TrainingView.ViewModel
	
	var body: some View {
		VStack {
			Text(exercise.name)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			ForEach(exercise.sets) {
				Text("\($0.desc())")
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			
			if showTextField {
				HStack {
					Text("\(exercise.sets.count + 1)")
					
					TextField("no reps", value: $noSeries, format: .number)
					
					Spacer()
					
					Button("Save", systemImage: "checkmark") {
						viewModel.addExerciseSet(to: exercise)
						noSeries = 0
					}
				}
			}
		}
		.padding(.horizontal)
	}
}
