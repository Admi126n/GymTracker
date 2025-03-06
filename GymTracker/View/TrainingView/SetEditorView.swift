//
//  SetEditorView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 26/02/2025.
//

#if DEBUG
import SwiftData
#endif

import SwiftUI

struct SetEditorView: View {
	
	@Bindable var exercise: ExerciseModel
	
	@State private var stats: [ExerciseStatistic: Double]
	
	let completion: () -> Void
	
	var body: some View {
		HStack {
			Text("\(exercise.sets.count + 1).")
			
			if exercise.mainStat == .weight && exercise.optionalStats == [.repetitions] {
				TextField("Weight", value: dictBinding(for: .weight), format: .number)
					.keyboardType(.decimalPad)
					.frame(width: 50)
					.textFieldStyle(.roundedBorder)
				
				Text("kg x")
				
				TextField("Repetitions", value: dictBinding(for: .repetitions), format: .number)
					.keyboardType(.numberPad)
					.textFieldStyle(.roundedBorder)
			} else {
				VStack {
					HStack {
						Text(exercise.mainStat.rawValue)
						
						TextField("Value", value: dictBinding(for: exercise.mainStat), format: .number)
							.keyboardType(.decimalPad)
							.textFieldStyle(.roundedBorder)
					}
					
					ForEach(exercise.optionalStats, id: \.self) { stat in
						HStack {
							Text(stat.rawValue)
							
							TextField("Value", value: dictBinding(for: stat), format: .number)
								.keyboardType(.decimalPad)
								.textFieldStyle(.roundedBorder)
						}
					}
				}
			}
			
			Spacer()
			
			Button("Save", systemImage: "checkmark") {
				withAnimation(.easeOut) {
					exercise.addSet(stats: stats)
					clearValues()
				}
				completion()
			}
		}
	}
	
	init(exercise: ExerciseModel, completion: @escaping () -> Void) {
		self.exercise = exercise
		self.stats = exercise.optionalStats.reduce(into: [:]) { $0[$1] = 0 }
		self.completion = completion
	}
	
	private func clearValues() {
		stats = exercise.optionalStats.reduce(into: [:]) { $0[$1] = 0 }
	}
	
	private func dictBinding(for key: ExerciseStatistic) -> Binding<Double> {
		return Binding(
			get: { stats[key, default: 0] },
			set: { stats[key] = $0 }
		)
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: ExerciseModel.self, configurations: config)
		let exercise = ExerciseModel(name: "Push ups", mainStat: .repetitions)
		
		return SetEditorView(exercise: exercise, completion: {})
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container")
	}
}
