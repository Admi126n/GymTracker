//
//  TrainingView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 18/02/2025.
//

import SwiftData
import SwiftUI

struct TrainingView: View {
	
	@Bindable var training: TrainingModel
	
	@Environment(\.dismiss) var dismiss
	
	@State private var viewModel: ViewModel
	@State private var showingNewExerciseView = false
	
	var body: some View {
		ZStack {
			Color.teal
				.ignoresSafeArea(.all)
			
			VStack {
				Text(training.name)
				
				Button("End training", role: .destructive) {
					ExerciseStatsManager.shared.addOrUpdateStats(training.exercises)
					
					dismiss()
				}
				.buttonStyle(.bordered)
				
				ForEach(training.exercises) { exercise in
					ExerciseView(showTextField: training.exercises.last == exercise, exercise: exercise, viewModel: viewModel)
				}
				
				Spacer()
				
				Button("Next exercise") {
					showingNewExerciseView.toggle()
				}
				.buttonStyle(.borderedProminent)
			}
			.containerRelativeFrame([.horizontal], alignment: .top)
			.sheet(isPresented: $showingNewExerciseView) {
				NewExerciseView { newExercise in
					training.exercises.append(newExercise)
				}
			}
		}
	}
	
	init(training: TrainingModel) {
		self.training = training
		self._viewModel = State(initialValue: ViewModel(training: training))
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: TrainingModel.self, configurations: config)
		let training = TrainingModel(startDate: .now)
		return TrainingView(training: training)
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container")
	}
}

struct ExerciseView: View {
	
	let showTextField: Bool
	
	@Bindable var exercise: ExerciseModel
	
	@State var value = 0.0
	@State var viewModel: TrainingView.ViewModel
	
	var body: some View {
		VStack {
			Text(exercise.name)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			ForEach(exercise.sets) {
				Text("\($0.description)")
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			
			if showTextField {
				HStack {
					Text("\(exercise.sets.count + 1)")
					
					TextField("main stat value", value: $value, format: .number)
					
					Spacer()
					
					Button("Save", systemImage: "checkmark") {
						viewModel.addExerciseSet(to: exercise, value: value)
						value = 0
					}
				}
			}
		}
		.padding(.horizontal)
	}
}
