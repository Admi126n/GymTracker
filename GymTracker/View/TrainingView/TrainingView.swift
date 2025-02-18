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
					ExerciseView(showTextField: training.exercises.last == exercise, exercise: exercise)
				}
				
				Spacer()
				
				Button("Next exercise") {
					let exercise = Exercise(name: "Bench Press", sets: [], options: [.reps, .weight])
					training.exercises.append(exercise)
				}
				.buttonStyle(.borderedProminent)
			}
			.containerRelativeFrame([.horizontal], alignment: .top)
		}
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
						let exerciseSet = ExerciseSet(repetitions: noSeries, weight: nil, time: nil, distance: nil)
						exercise.sets.append(exerciseSet)
						noSeries = 0
					}
				}
			}
		}
		.padding(.horizontal)
	}
}
