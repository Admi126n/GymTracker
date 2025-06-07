//
//  StatisticsMainView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 18/02/2025.
//

import SwiftData
import SwiftUI

struct StatisticsMainView: View {
	
	@Query private var trainings: [TrainingModel]
	@Query private var exercises: [ExerciseModel]
	
    var body: some View {
		VStack {
			Text("TrainingModels count: \(trainings.count)")
			
			Text("Exercises count: \(exercises.count)")
		}
    }
}

#Preview {
    StatisticsMainView()
}
