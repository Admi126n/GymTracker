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
	
	@FocusState private var focused: ExerciseStatistic?
	
	@State private var stats: [ExerciseStatistic: String]
	@State private var showSheet = false
	
	let completion: () -> Void
	
	var statsValid: Bool {
		stats.allSatisfy { Double($0.value.replacingOccurrences(of: ",", with: ".")) != nil }
	}
	
	var statsAsDoubles: [ExerciseStatistic: Double] {
		Dictionary(uniqueKeysWithValues: stats.map { key, value in
			(key, Double(value.replacingOccurrences(of: ",", with: ".")) ?? 0)
		})
	}
	
	var body: some View {
		VStack {
			HStack {
				Text("\(exercise.sets.count + 1).")
				
				VStack(alignment: .leading) {
					ForEach(exercise.allStats.sorted { $0.rawValue < $1.rawValue }, id: \.self) { stat in
						if stat.isTimeReleated {
							HStack {
								StatSymbolView(symbolName: stat.symbol, mainStat: stat == exercise.mainStat)
								
								Group {
									if let value = stats[stat], let numValue = Double(value), numValue != 0 {
										Text(numValue.asTimeComponents)
									} else {
										Text(stat.rawValue)
											.foregroundStyle(.tertiary)
									}
								}
								.frame(maxWidth: .infinity, alignment: .leading)
								.statTextField()
								.onTapGesture {
									showSheet = true
								}
								.padding(.trailing, 8)
								.padding(.bottom, 4)
							}
							.sheet(isPresented: $showSheet) {
								TimePickerSheet(value: dictBinding(for: stat))
							}
						} else {
							HStack {
								StatSymbolView(symbolName: stat.symbol, mainStat: stat == exercise.mainStat)
								
								TextField(stat.rawValue, text: stringDictBinding(for: stat))
									.keyboardType(stat == .repetitions ? .numberPad : .decimalPad)
									.statTextField()
									.focused($focused, equals: stat)
								
								Text(stat.unit)
							}
						}
					}
				}
			}
			
			Rectangle()
				.frame(height: 10)
				.foregroundStyle(.clear)
			
			HStack {
				Spacer()
				
				Button("Next set") {
					withAnimation(.easeOut) {
						exercise.addSet(stats: statsAsDoubles)
						clearValues()
					}
					completion()
				}
				.buttonStyle(Pressable(background: .green, foreground: .background))
				.disabled(!statsValid)
				
				Spacer()
			}
		}
		.toolbar {
			if focused != nil {
				ToolbarItemGroup(placement: .keyboard) {
					if focused == .weight {
						Button {
							withAnimation {
								guard let value = stats[.weight] else { return }
								
								stats[.weight] = "-" + value
							}
						} label: {
							Image(systemName: "plus.forwardslash.minus")
						}
					}
					
					Spacer()
					// Add logic to change focus state to next field
					Button("Done") {
						focused = nil
					}
				}
			}
		}
	}
	
	init(exercise: ExerciseModel, completion: @escaping () -> Void) {
		self.exercise = exercise
		self.stats = exercise.allStats.reduce(into: [:]) { $0[$1] = "" }
		self.completion = completion
	}
	
	private func clearValues() {
		stats = exercise.allStats.reduce(into: [:]) { $0[$1] = "" }
	}
	
	private func dictBinding(for key: ExerciseStatistic) -> Binding<Double> {
		return Binding(
			get: { Double(stats[key, default: "0"]) ?? 0 },
			set: { stats[key] = String($0) }
		)
	}
	
	private func stringDictBinding(for key: ExerciseStatistic) -> Binding<String> {
		return Binding(
			get: { stats[key, default: ""] },
			set: { stats[key] = validateInput($0) }
		)
	}
	
	private func validateInput(_ text: String) -> String {
		let components = text.components(separatedBy: ",")
		if components.count > 2 {
			return "\(components.first!),\(components.last!)"
		}
		
		return text.filter { "0123456789,-".contains($0) }
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: ExerciseModel.self, configurations: config)
		let exercise = ExerciseModel(
			name: "Push ups",
			mainStat: .weight,
			optionalStats: [.duration, .distance, .repetitions])
		
		return SetEditorView(exercise: exercise, completion: {})
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container")
	}
}

private struct StatTextField: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding(4)
			.background(.background)
			.clipShape(.rect(cornerRadius: 5))
			.overlay {
				RoundedRectangle(cornerRadius: 5, style: .circular)
					.stroke(.quinary, lineWidth: 1)
			}
	}
}

private extension View {
	func statTextField() -> some View {
		modifier(StatTextField())
	}
}
