//
//  ContentView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 13/02/2025.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack {
			Image(systemName: "figure.strengthtraining.traditional")
				.imageScale(.large)
				.foregroundStyle(.tint)
			Text("Gym Tracker!")
		}
		.padding()
	}
}

#Preview {
	ContentView()
}
