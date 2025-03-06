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
	
	@State private var viewModel: ViewModel
	@State private var showingNewExerciseView = false
	
	var body: some View {
		VStack {
			Text(training.name)
			
			Button("End training", role: .destructive) {
				ExerciseRecordManager.shared.addOrUpdateStats(training.exercises)
				
				dismiss()
			}
			.buttonStyle(.bordered)
			
			ScrollViewReader { proxy in
				ScrollView {
					ForEach(training.exercises) { exercise in
						ExerciseView(exercise: exercise, viewModel: viewModel, showTextField: training.exercises.last == exercise) {
							scrollToBottom(proxy)
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
			.buttonStyle(.borderedProminent)
		}
		.sheet(isPresented: $showingNewExerciseView) {
			NewExerciseView { newExercise in
				training.addExercise(newExercise)
			}
		}
	}
	
	init(training: TrainingModel) {
		self.training = training
		self._viewModel = State(initialValue: ViewModel(training: training))
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
		let exercise = ExerciseModel(name: "Hello", mainStat: .weight)
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

struct ExerciseView: View {
	
	@Bindable var exercise: ExerciseModel
	
	@State var viewModel: TrainingView.ViewModel
	@State private var isExpanded = true
	
	let showTextField: Bool
	let completion: () -> Void
	
	var body: some View {
		VStack {
			HStack {
				Text(exercise.name)
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(.title2)
				
				Text("Max: \(ExerciseRecordManager.shared.getBestForExerciseWith(uuid: exercise.uuid))")
				
				Spacer(minLength: 0)
				
				if !showTextField {
					Image(systemName: "chevron.up")
						.rotationEffect(.init(degrees: isExpanded ? 0 : 180))
				}
			}
			.contentShape(.rect)
			.onTapGesture {
				if !showTextField {
					withAnimation(.bouncy) {
						isExpanded.toggle()
					}
				}
			}
			
			if isExpanded {
				ForEach(exercise.sets) {
					Text("\($0.description)")
						.frame(maxWidth: .infinity, alignment: .leading)
						.overlay(
							RoundedRectangle(cornerRadius: 5)
								.stroke(.secondary, lineWidth: 1)
						)
				}
			}
			
			if showTextField {
				SetEditorView(exercise: exercise, completion: completion)
			}
		}
		.padding()
		.overlay {
			RoundedRectangle(cornerRadius: 5)
				.stroke(.secondary, lineWidth: 1)
		}
		.clipShape(.rect(cornerRadius: 5))
		.padding(.horizontal)
	}
}
