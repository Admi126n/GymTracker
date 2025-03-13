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
			
			if exercise.seatHeight == nil {
				Button {
					showAlert = true
				} label: {
					Label("Add seat height", systemImage: "pencil")
						.font(.footnote)
				}
			} else {
				Button {
					showAlert = true
				} label: {
					Label("Seat height: \(exercise.seatHeight!)", systemImage: "chair")
						.font(.footnote)
				}
			}
			
			if isExpanded {
				Rectangle()
					.frame(height: 1)
					.foregroundStyle(.secondary)
				
				ForEach(Array(zip(exercise.sets.indices, exercise.sets)), id: \.0) { index, item in
					HStack {
						Text("\(index + 1).")
						
						setDescription(item)
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
	
	private func setDescription(_ set: SetModel) -> some View {
		VStack(alignment: .leading) {
			ForEach(set.stats.keys.sorted { $0.rawValue < $1.rawValue }, id: \.self) { stat in
				HStack {
					StatSymbolView(symbolName: stat.symbol, mainStat: stat == exercise.mainStat)
				
					switch stat {
					case .speed, .duration:
						Text(set.stats[stat]!.asTimeComponents)
					default:
						Text(set.stats[stat]!, format: .number)
					}
					
					Text(stat.unit)
				}
			}
		}
	}
}

#Preview {
	ExerciseView(exercise: ExerciseModel(name: "Push ups", mainStat: .repetitions), showTextField: true) { }
}
