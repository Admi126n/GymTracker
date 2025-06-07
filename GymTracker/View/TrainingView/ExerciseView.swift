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
	@State private var seatHeight: String
	@State private var showAlert = false
	
	let record: Double
	let showTextField: Bool
	let completion: () -> Void
	let deleteExercise: (() -> Void)?
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(exercise.name)
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(.title2)
				
				Spacer()
				
				Menu {
					Button("Set seat height") {
						showAlert = true
					}
					
					Button("Delete", role: .destructive) {
						withAnimation {
							deleteExercise?()
						}
					}
				} label: {
					Label("Info", systemImage: "ellipsis.circle")
						.labelStyle(.iconOnly)
						.tint(.green)
				}
			}
			.contentShape(.rect)
			
			if isExpanded {
				if exercise.seatHeight != nil {
					Button {
						showAlert = true
					} label: {
						Text("Seat height: \(exercise.seatHeight!)")
							.font(.footnote)
					}
					.tint(.green)
				}
				
				if record != 0 {
					if exercise.mainStat.isTimeReleated {
						Text("Best: \(record.asTimeComponents) \(exercise.mainStat.unit)")
					} else {
						Text("Best: ") +
						Text(record, format: .number) +
						Text(" \(exercise.mainStat.unit)")
					}
				}
				
				Rectangle()
					.frame(height: 1)
					.foregroundStyle(.secondary)
				
				ForEach(Array(zip(exercise.sets.indices, exercise.sets)), id: \.0) { index, item in
					SwipableView(cornerRadius: 10, action: .delete(action: {
						exercise.remove(set: item)
					})) {
					
						HStack {
							Text("\(index + 1).")
							
							SetDescriptionView(set: item)
						}
					}
					
					Rectangle()
						.frame(height: 1)
						.foregroundStyle(.secondary)
				}
			}
			
			if showTextField {
				SetEditorView(exercise: exercise, completion: completion)
			} else {
				HStack {
					Spacer()
					
					Image(systemName: "chevron.up")
						.rotationEffect(.init(degrees: isExpanded ? 0 : 180))
						.foregroundStyle(.green)
					
					Spacer()
				}
				.padding(.top, 4)
				.contentShape(.rect)
				.onTapGesture {
					if !showTextField {
						withAnimation(.bouncy) {
							isExpanded.toggle()
						}
					}
				}
			}
		}
		.padding(16)
		.background(.quaternary)
		.clipShape(.rect(cornerRadius: 15, style: .continuous))
		.padding(.horizontal)
		.onChange(of: showTextField) { _, newValue in
			withAnimation(.bouncy) {
				isExpanded = newValue
			}
		}
		.alert("Set seat height", isPresented: $showAlert) {
			TextField("Seat height", text: $seatHeight)
			Button("OK") {
				exercise.setSeatHeight(seatHeight)
			}
		}
	}
	
	init(
		exercise: ExerciseModel,
		showTextField: Bool,
		completion: @escaping () -> Void,
		deleteExercise: (() -> Void)? = nil
	) {
		self.exercise = exercise
		self.showTextField = showTextField
		self.completion = completion
		self.deleteExercise = deleteExercise
		self._isExpanded = State(initialValue: showTextField)
		self._seatHeight = State(initialValue: exercise.seatHeight ?? "")
		self.record = ExerciseRecordManager.shared.getBestForExerciseWith(uuid: exercise.uuid)
	}
}

#Preview {
	ExerciseView(exercise: ExerciseModel(name: "Push ups", mainStat: .weight), showTextField: true) { }
}
