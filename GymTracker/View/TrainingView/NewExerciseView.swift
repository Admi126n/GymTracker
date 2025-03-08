//
//  NewExerciseView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 19/02/2025.
//

import SwiftUI

struct NewExerciseView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@StateObject private var vModel = ViewModel()
	
	@State private var exerciseSelected = false
	
	let savedExercises: [ExerciseRecord]
	let completion: (ExerciseModel) -> Void
	
	private var filteredSavedExercises: [ExerciseRecord] {
		if vModel.name.isEmpty {
			return savedExercises.sorted { $0.name < $1.name }
		} else {
			return savedExercises.filter { $0.name.starts(with: vModel.name) }
				.sorted { $0.name < $1.name }
		}
	}
	
	var body: some View {
		ScrollView(.vertical) {
			VStack {
				TextField("Exercise name", text: $vModel.name)
					.textFieldStyle(.roundedBorder)
				
				if !exerciseSelected {
					VStack {
						if !vModel.name.isEmpty {
							Text("Add new: \(vModel.name)")
								.frame(maxWidth: .infinity, alignment: .leading)
								.fontWeight(.bold)
								.contentShape(.rect)
								.padding(4)
								.overlay(
									RoundedRectangle(cornerRadius: 5)
										.stroke(.secondary, lineWidth: 1)
								)
								.onTapGesture {
									setStats()
								}
						}
						
						ForEach(filteredSavedExercises, id: \.self) { record in
							ExerciseRecordCell(exerciseRecord: record)
								.onTapGesture {
									setStatsWith(record: record)
								}
						}
					}
				}
				
				if exerciseSelected {
					MainStatPickerView(stat: $vModel.mainStat)
					
					ForEach(vModel.optionalStatsCases, id: \.self) { stat in
						Toggle(isOn: Binding(
							get: { vModel.optionalStats.contains(stat) },
							set: { isSelected in
								if isSelected {
									vModel.optionalStats.insert(stat)
								} else {
									vModel.optionalStats.remove(stat)
								}
							}
						)) {
							Text(stat.rawValue)
						}
					}
					
					Spacer()
					
					Button("Add") {
						if let selectedRecord = vModel.selectedRecord,
						   selectedRecord.hasEqualProperties(name: vModel.name,
															 mainStat: vModel.mainStat,
															 optionalStats: Array(vModel.optionalStats)) {
							
							let exercise = ExerciseModel(exerciseRecord: selectedRecord)
							completion(exercise)
						} else {
							let exercise = ExerciseModel(name: vModel.name,
														 mainStat: vModel.mainStat,
														 optionalStats: Array(vModel.optionalStats))
							completion(exercise)
						}
						
						dismiss()
					}
					.disabled(!exerciseSelected)
					.buttonStyle(.borderedProminent)
				}
			}
			.padding()
		}
		.onChange(of: vModel.name) { oldValue, _ in
			if !oldValue.isEmpty {
				exerciseSelected = false
			}
		}
		.onChange(of: vModel.mainStat) { oldValue, _ in
			vModel.optionalStats.remove(oldValue)
		}
	}
	
	init(completion: @escaping (ExerciseModel) -> Void) {
		self.savedExercises = ExerciseRecordManager.shared.loadStats()
		self.completion = completion
	}
	
	private func setStatsWith(record: ExerciseRecord) {
		withAnimation {
			vModel.name = record.name
			vModel.mainStat = record.mainStat
			vModel.optionalStats = Set(record.optionalStats)
			
			vModel.selectedRecord = record
			exerciseSelected = true
		}
	}
	
	private func setStats() {
		withAnimation {
			exerciseSelected = true
		}
	}
}

#Preview {
	NewExerciseView { _ in }
}
