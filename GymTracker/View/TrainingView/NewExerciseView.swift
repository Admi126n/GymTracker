//
//  NewExerciseView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 19/02/2025.
//

import SwiftUI

struct SavedExerciseCell: View {
	
	let name: String
	let mainStat: MainStatistic?
	let additionalStats: [ExerciseStatistic]
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(name)
				.frame(maxWidth: .infinity, alignment: .leading)
				.fontWeight(.bold)
			
			if let mainStat = mainStat {
				Text("Main stat: \(mainStat.type), \(mainStat.value)")
					.font(.subheadline)
				
			}
			HStack {
				ForEach(additionalStats, id: \.self) {
					Text($0.rawValue)
						.font(.footnote)
				}
			}
		}
		.contentShape(.rect)
		.padding(4)
		.overlay(
			RoundedRectangle(cornerRadius: 5)
				.stroke(.secondary, lineWidth: 1)
		)
	}
	
	init(name: String) {
		self.name = "New: \(name)"
		self.mainStat = nil
		self.additionalStats = []
	}
	
	init(savedStats: ExerciseStats) {
		self.name = savedStats.name
		self.mainStat = .init(type: savedStats.mainStat, value: savedStats.record)
		self.additionalStats = savedStats.additionalStats
	}
}

struct NewExerciseView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@State private var name: String = ""
	@State private var mainStatistic: ExerciseStatistic = .weight
	@State private var additionalStats: Set<ExerciseStatistic> = []
	@State private var exerciseSelected = false
	
	let savedExercises: [ExerciseStats]
	let completion: (ExerciseModel) -> Void
	
	private var additionalCases: [ExerciseStatistic] {
		ExerciseStatistic.allCases.filter { $0 != mainStatistic }
	}
	
	private var filteredSavedExercises: [ExerciseStats] {
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
							SavedExerciseCell(name: name)
								.onTapGesture {
									setStats()
								}
						}
						
						ForEach(filteredSavedExercises, id: \.self) { stat in
							SavedExerciseCell(savedStats: stat)
								.onTapGesture {
									setStats(stat)
								}
						}
					}
				}
				
				if exerciseSelected {
					MainStatPickerView(stat: $mainStatistic)
					
					Picker("Main statistic", selection: $mainStatistic) {
						ForEach(ExerciseStatistic.allCases, id: \.self) { stat in
							Text(stat.rawValue)
								.tag(stat)
						}
					}
					
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
						let exercise = ExerciseModel(name: name, mainStat: mainStatistic, additionalStats: Array(additionalStats))
						completion(exercise)
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
		self.savedExercises = ExerciseStatsManager.shared.loadStats()
		self.completion = completion
	}
	
	private func setStats(_ stats: ExerciseStats) {
		withAnimation {
			mainStatistic = stats.mainStat
			additionalStats = Set(stats.additionalStats)
			name = stats.name
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
