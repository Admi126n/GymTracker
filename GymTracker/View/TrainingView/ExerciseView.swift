//
//  ExerciseView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 08/03/2025.
//

import SwiftUI

struct ExerciseView: View {
	
	@Bindable var exercise: ExerciseModel

	@State private var isExpanded: Bool
	
	let record: Double
	let showTextField: Bool
	let completion: () -> Void
	
	var body: some View {
		VStack {
			HStack {
				Text(exercise.name)
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(.title2)
				
				if record != 0 {
					Text("Max: ") +
					Text(record, format: .number) +
					Text(" \(exercise.mainStat.unit)")
				}
				
				Spacer(minLength: 0)
				
				if !showTextField {
					Image(systemName: "chevron.up")
						.rotationEffect(.init(degrees: isExpanded ? 0 : 180))
						.foregroundStyle(.indigo)
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
				Rectangle()
					.frame(height: 1)
					.foregroundStyle(.secondary)
				
				ForEach(Array(zip(exercise.sets.indices, exercise.sets)), id: \.0) { index, item in
					HStack {
						Text("\(index + 1).")
						
						Text("\(item.description)")
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					
					Rectangle()
						.frame(height: 1)
						.foregroundStyle(.secondary)
				}
			}
			
			if showTextField {
				SetEditorView(exercise: exercise, completion: completion)
			}
		}
		.padding()
		.background(HierarchicalShapeStyle.quaternary)
		.overlay {
			RoundedRectangle(cornerRadius: 15, style: .continuous)
				.stroke(.secondary, lineWidth: 5)
		}
		.clipShape(.rect(cornerRadius: 15, style: .continuous))
		.padding(.horizontal)
		.onChange(of: showTextField) { _, newValue in
			withAnimation(.bouncy) {
				isExpanded = newValue
			}
		}
	}
	
	init(
		exercise: ExerciseModel,
		showTextField: Bool,
		completion: @escaping () -> Void
	) {
		self.exercise = exercise
		self.showTextField = showTextField
		self.completion = completion
		self._isExpanded = State(initialValue: showTextField)
		self.record = ExerciseRecordManager.shared.getBestForExerciseWith(uuid: exercise.uuid)
	}
}

#Preview {
	ExerciseView(exercise: ExerciseModel(name: "Push ups", mainStat: .repetitions), showTextField: true) { }
}
