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
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				VStack(alignment: .leading) {
					Text(exercise.name)
						.frame(maxWidth: .infinity, alignment: .leading)
						.font(.title2)
				
					if exercise.seatHeight == nil {
						Button {
							showAlert = true
						} label: {
							Text("Add seat height")
								.font(.footnote)
						}
						.tint(.green)
					} else {
						Button {
							showAlert = true
						} label: {
							Text("Seat height: \(exercise.seatHeight!)")
								.font(.footnote)
						}
						.tint(.green)
					}
				}
				
				Spacer()
				
				if record != 0 {
					if exercise.mainStat == .duration || exercise.mainStat == .speed {
						Text("Best: \(record.asTimeComponents) \(exercise.mainStat.unit)")
					} else {
						Text("Best: ") +
						Text(record, format: .number) +
						Text(" \(exercise.mainStat.unit)")
					}
				}
				
				if !showTextField {
					Image(systemName: "chevron.up")
						.rotationEffect(.init(degrees: isExpanded ? 0 : 180))
						.foregroundStyle(.green)
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
						
						SetDescriptionView(set: item)
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
		completion: @escaping () -> Void
	) {
		self.exercise = exercise
		self.showTextField = showTextField
		self.completion = completion
		self._isExpanded = State(initialValue: showTextField)
		self._seatHeight = State(initialValue: exercise.seatHeight ?? "")
		self.record = ExerciseRecordManager.shared.getBestForExerciseWith(uuid: exercise.uuid)
	}
}

#Preview {
	ExerciseView(exercise: ExerciseModel(name: "Push ups", mainStat: .weight), showTextField: true) { }
}
