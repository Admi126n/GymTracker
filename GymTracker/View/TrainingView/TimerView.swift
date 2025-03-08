//
//  TimerView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 08/03/2025.
//

import SwiftUI

struct TimerView: View {
	
	@State private var currentDate: Date = .now
	
	let date: Date
	
	var body: some View {
		Text(timerInterval: date...currentDate,
			 countsDown: false,
			 showsHours: true)
		.font(.title)
		.fontDesign(.rounded)
		.bold()
		.onAppear {
			Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
				currentDate = Date()
			}
		}
	}
	
	init(from date: Date) {
		self.date = date
	}
}

#Preview {
	TimerView(from: .now)
}
