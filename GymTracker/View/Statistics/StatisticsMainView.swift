//
//  StatisticsMainView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 18/02/2025.
//

import SwiftData
import SwiftUI

struct StatisticsMainView: View {
	
	@Query private var trainings: [Training]
	@Query private var exercises: [Exercise]
	
    var body: some View {
		VStack {
			Text("Trainings count: \(trainings.count)")
			
			Text("Exercises count: \(exercises.count)")
		}
    }
}

#Preview {
    StatisticsMainView()
}
