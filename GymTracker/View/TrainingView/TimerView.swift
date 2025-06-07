//
//  TimerView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 08/03/2025.
//

import SwiftUI

struct TimerView: View {
	
	let font: Font
	let date: Date
	
	var body: some View {
		Text(Date(timeIntervalSinceNow: date.timeIntervalSince1970 - Date().timeIntervalSince1970), style: .timer)
			.font(font)
			.fontDesign(.rounded)
			.bold()
	}
	
	init(from date: Date, font: Font = .title) {
		self.date = date
		self.font = font
	}
}

#Preview {
	TimerView(from: .now)
}
