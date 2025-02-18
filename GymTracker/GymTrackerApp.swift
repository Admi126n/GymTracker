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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(for: Training.self)
    }
}
