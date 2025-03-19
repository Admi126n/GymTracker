//
//  TimerView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 08/03/2025.
//

import SwiftUI

struct TimerView: View {
	
	let date: Date
	
	var body: some View {
		Text(Date(timeIntervalSinceNow: date.timeIntervalSince1970 - Date().timeIntervalSince1970), style: .timer)
			.font(.title)
			.fontDesign(.rounded)
			.bold()
	}
	
	init(from date: Date) {
		self.date = date
	}
}

#Preview {
	TimerView(from: .now)
}
