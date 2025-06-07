//
//  StatSymbolView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 10/03/2025.
//

import SwiftUI

struct StatSymbolView: View {
	
	let symbolName: String
	let mainStat: Bool
	
    var body: some View {
		Image(systemName: symbolName)
			.bold(mainStat)
			.foregroundStyle(mainStat ? .green : .primary)
			.frame(width: 25)
    }
}

#Preview {
	StatSymbolView(symbolName: "chair", mainStat: false)
}
