//
//  SetDescriptionView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 16/03/2025.
//

import SwiftUI

struct SetDescriptionView: View {
	
	let set: SetModel
	
	var body: some View {
			VStack(alignment: .leading) {
				ForEach(set.stats.keys.sorted { $0.rawValue < $1.rawValue }, id: \.self) { stat in
					HStack {
						StatSymbolView(symbolName: stat.symbol, mainStat: stat == set.mainStat)
					
						if stat.isTimeReleated {
							Text(set.stats[stat]!.asTimeComponents)
						} else {
							Text(set.stats[stat]!, format: .number)
						}
						
						Text(stat.unit)
					}
				}
		}
	}
}

#Preview {
	SetDescriptionView(set: .init(mainStat: .distance, stats: [.distance: 10, .weight: 10]))
}
