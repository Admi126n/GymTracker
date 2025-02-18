//
//  GymTrackerApp.swift
//  GymTracker
//
//  Created by Adam Tokarski on 13/02/2025.
//

import SwiftData
import SwiftUI

@main
struct GymTrackerApp: App {
	
	let container: ModelContainer
	
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
		.modelContainer(container)
	}
	
	init() {
		do {
			container = try ModelContainer(for: Training.self)
		} catch {
			fatalError("Failed to create ModelContainer for Movie.")
		}
	}
}
