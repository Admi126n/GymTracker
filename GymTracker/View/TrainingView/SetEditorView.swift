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
	
	@State private var stats: [ExerciseStatistic: Double]
	@State private var showSheet = false
	
	let completion: () -> Void
	
	private let numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .none
		formatter.zeroSymbol  = ""
		return formatter
	}()
	
	var body: some View {
		VStack {
			HStack {
				Text("\(exercise.sets.count + 1).")
				
				VStack(alignment: .leading) {
					ForEach(exercise.allStats.sorted { $0.rawValue < $1.rawValue }, id: \.self) { stat in
						if stat == .speed || stat == .duration {
							HStack {
								StatSymbolView(symbolName: stat.symbol, mainStat: stat == exercise.mainStat)
								
								Group {
									if stats[stat]! == 0 {
										Text(stat.rawValue)
											.foregroundStyle(.tertiary)
									} else {
										Text(stats[stat]!.asTimeComponents)
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
								
								TextField(stat.rawValue, value: dictBinding(for: stat), formatter: numberFormatter)
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
						exercise.addSet(stats: stats)
						clearValues()
					}
					completion()
				}
				.buttonStyle(Pressable(background: .green, foreground: .background))
				.disabled(stats.allSatisfy { $1.isZero })
				
				Spacer()
			}
		}
		.toolbar {
			if focused != nil {
				ToolbarItemGroup(placement: .keyboard) {
					if focused == .weight {
						Button {
							withAnimation {
								stats[.weight]! *= -1
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
		self.stats = exercise.allStats.reduce(into: [:]) { $0[$1] = 0 }
		self.completion = completion
	}
	
	private func clearValues() {
		stats = exercise.allStats.reduce(into: [:]) { $0[$1] = 0 }
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
