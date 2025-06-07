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
						.foregroundStyle(statistic == stat ? .green : .secondary)
						.fontWeight(statistic == stat ? .bold : nil)
					
					if statistic == stat {
						Text(statistic.rawValue)
					}
				}
				.frame(height: 40)
				.frame(minWidth: 40, maxWidth: statistic == stat ? .infinity : nil)
				.padding(.horizontal, 4)
				.clipShape(.rect(cornerRadius: 15, style: .continuous))
				.contentShape(.rect)
				.overlay {
					RoundedRectangle(cornerRadius: 15, style: .continuous)
						.stroke(statistic == stat ? Color.green : .secondary, lineWidth: 2)
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
