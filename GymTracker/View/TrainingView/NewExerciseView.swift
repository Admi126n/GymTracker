//
//  NewExerciseView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 19/02/2025.
//

import SwiftUI

struct SavedExerciseCell: View {
	
	let exerciseRecord: ExerciseRecord
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(exerciseRecord.name)
				.frame(maxWidth: .infinity, alignment: .leading)
				.fontWeight(.bold)
			
			Text("Main stat: \(exerciseRecord.mainStat.rawValue), \(exerciseRecord.record)")
				.font(.subheadline)
			
			HStack {
				ForEach(exerciseRecord.optionalStats, id: \.self) {
					Text($0.rawValue)
						.font(.footnote)
				}
			}
		}
		.contentShape(.rect)
		.padding(8)
		.background(HierarchicalShapeStyle.quaternary)
		.overlay {
			RoundedRectangle(cornerRadius: 15, style: .continuous)
				.stroke(.indigo, lineWidth: 5)
		}
		.clipShape(.rect(cornerRadius: 15, style: .continuous))
	}
}

struct NewExerciseView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@State private var name: String = ""
	@State private var mainStatistic: ExerciseStatistic = .weight
	@State private var additionalStats: Set<ExerciseStatistic> = []
	@State private var exerciseSelected = false
	@State private var selectedRecord: ExerciseRecord?
	
	let savedExercises: [ExerciseRecord]
	let completion: (ExerciseModel) -> Void
	
	private var additionalCases: [ExerciseStatistic] {
		ExerciseStatistic.allCases.filter { $0 != mainStatistic }
	}
	
	private var filteredSavedExercises: [ExerciseRecord] {
		if name.isEmpty {
			return savedExercises.sorted { $0.name < $1.name }
		} else {
			return savedExercises.filter { $0.name.starts(with: name) }
				.sorted { $0.name < $1.name }
		}
	}
	
	var body: some View {
		ScrollView(.vertical) {
			VStack {
				TextField("Exercise name", text: $name)
					.textFieldStyle(.roundedBorder)
				
				if !exerciseSelected {
					VStack {
						if !name.isEmpty {
							Text("Add new: \(name)")
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
							SavedExerciseCell(exerciseRecord: record)
								.onTapGesture {
									setStatsWith(record: record)
								}
						}
					}
				}
				
				if exerciseSelected {
					MainStatPickerView(stat: $mainStatistic)
					
					ForEach(ExerciseStatistic.allCases, id: \.self) { stat in
						if stat != mainStatistic {
							Toggle(isOn: Binding(
								get: { additionalStats.contains(stat) },
								set: { isSelected in
									if isSelected {
										additionalStats.insert(stat)
									} else {
										additionalStats.remove(stat)
									}
								}
							)) {
								Text(stat.rawValue)
							}
						}
					}
					
					Spacer()
					
					Button("Add") {
						if let selectedRecord = selectedRecord {
							let exercise = ExerciseModel(exerciseRecord: selectedRecord)
							completion(exercise)
						} else {
							let exercise = ExerciseModel(name: name, mainStat: mainStatistic, optionalStats: Array(additionalStats))
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
		.onChange(of: name) { oldValue, _ in
			if !oldValue.isEmpty {
				exerciseSelected = false
			}
		}
		.onChange(of: mainStatistic) { oldValue, _ in
			additionalStats.remove(oldValue)
		}
	}
	
	init(completion: @escaping (ExerciseModel) -> Void) {
		self.savedExercises = ExerciseRecordManager.shared.loadStats()
		self.completion = completion
	}
	
	private func setStatsWith(record: ExerciseRecord) {
		withAnimation {
			mainStatistic = record.mainStat
			additionalStats = Set(record.optionalStats)
			name = record.name
			selectedRecord = record
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
