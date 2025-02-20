//
//  ContentView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 13/02/2025.
//

#if DEBUG
import SwiftData
#endif

import SwiftUI

struct ContentView: View {
	var body: some View {
		MainTabView()
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: TrainingModel.self, configurations: config)
		return ContentView()
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container")
	}
}
