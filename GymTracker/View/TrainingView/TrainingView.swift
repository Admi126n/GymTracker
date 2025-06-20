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
	
	@Namespace var bottomId
	
	@State private var showingNewExerciseView = false
	
	var body: some View {
		NavigationStack {
			VStack {
				TimerView(from: Date(timeIntervalSince1970: training.startDate))
				
				if let exercise = training.exercises.last,
				   let set = exercise.sets.last {
					TimerView(from: Date(timeIntervalSince1970: set.timestamp), font: .body)
				}
				
				Button("End training", role: .destructive) {
					ExerciseRecordManager.shared.addOrUpdateStats(training.exercises)
					training.finishTraining()
					dismiss()
				}
				.buttonStyle(Pressable(background: .endButtonBackground, foreground: .red))
				
				ScrollViewReader { proxy in
					ScrollView {
						ForEach(training.exercises) { exercise in
							ExerciseView(exercise: exercise, showTextField: training.exercises.last == exercise) {
								scrollToBottom(proxy)
							} deleteExercise: {
								training.remove(exercise: exercise)
							}
						}
						
						Spacer()
							.frame(minHeight: 100)
							.id(bottomId)
					}
				}
				.containerRelativeFrame([.horizontal], alignment: .top)
				
				Button("Next exercise") {
					showingNewExerciseView.toggle()
				}
				.buttonStyle(Pressable(background: .green, foreground: .background))
				.padding(.bottom, 4)
			}
			.sheet(isPresented: $showingNewExerciseView) {
				NewExerciseView { newExercise in
					training.addExercise(newExercise)
				}
				.presentationDetents([.medium, .large])
			}
		}
	}
	
	init(training: TrainingModel) {
		self.training = training
	}
	
	private func scrollToBottom(_ proxy: ScrollViewProxy) {
		withAnimation(.easeOut) {
			proxy.scrollTo(bottomId, anchor: .top)
		}
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: TrainingModel.self, configurations: config)
		let training = TrainingModel(startDate: .now)
		let exercise = ExerciseModel(name: "Push ups", mainStat: .weight)
		for _ in 0...10 {
			exercise.addSet(stats: [.weight: 100])
		}
		
		training.addExercise(exercise)
		
		return TrainingView(training: training)
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container")
	}
}
