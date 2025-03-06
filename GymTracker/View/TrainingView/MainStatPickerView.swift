//
//  MainStatPickerView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 26/02/2025.
//

import SwiftUI

struct MainStatPickerView: View {
	
	@Binding var stat: ExerciseStatistic
	
	var body: some View {
		HStack(spacing: 4) {
			ForEach(ExerciseStatistic.allCases, id: \.self) { statistic in
				HStack {
					Image(systemName: statistic.symbol)
						.foregroundStyle(statistic == stat ? .primary : .secondary)
					
					if statistic == stat {
						Text(statistic.rawValue)
					}
				}
				.frame(height: 40)
				.frame(minWidth: 40, maxWidth: statistic == stat ? .infinity : nil)
				.padding(.horizontal, 4)
				.clipShape(.rect(cornerRadius: 5, style: .continuous))
				.contentShape(.rect)
				.overlay {
					RoundedRectangle(cornerRadius: 5)
						.stroke(.secondary, lineWidth: 1)
				}
				.onTapGesture {
					withAnimation(.bouncy) {
						stat = statistic
					}
				}
			}
		}
	}
	
}

#Preview {
	@Previewable @State var stat = ExerciseStatistic.weight
	
	MainStatPickerView(stat: $stat)
}
