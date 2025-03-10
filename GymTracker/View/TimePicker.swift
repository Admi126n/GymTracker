//
//  TimePicker.swift
//  GymTracker
//
//  Created by Adam Tokarski on 08/03/2025.
//

import SwiftUI

struct TimePicker: View {
	
	struct WheelPicker: View {
		
		@Binding var selection: Int
		
		let title: String
		let data: ClosedRange<Int>
		
		var body: some View {
			Picker(title, selection: $selection) {
				ForEach(data, id: \.self) {
					Text("\($0)")
				}
			}
			.pickerStyle(.wheel)
			.frame(minWidth: 50)
		}
	}
	
	@Binding var time: Double
	
	@State private var hours = 0
	@State private var minutes = 0
	@State private var seconds = 0
	
	var body: some View {
		HStack(spacing: -5) {
			WheelPicker(selection: $hours, title: "Hours", data: 0...23)
			
			Text("hours")
			
			WheelPicker(selection: $minutes, title: "Minutes", data: 0...59)
			
			Text("min")
			
			WheelPicker(selection: $seconds, title: "Seconds", data: 0...59)
			
			Text("sec")
		}
		.padding(.horizontal)
		.onChange(of: hours) { _, _ in
			setTime()
		}
		.onChange(of: minutes) { _, _ in
			setTime()
		}
		.onChange(of: seconds) { _, _ in
			setTime()
		}
	}
	
	private func setTime() {
		time = TimeInterval(hours * 3600 + minutes * 60 + seconds)
	}
	
	init(time: Binding<Double>) {
		self._time = time
		
		let tmpHours = Int(time.wrappedValue) / 3600
		let tmpMinutes = (Int(time.wrappedValue) - tmpHours * 3600) / 60
		let tmpSeconds = Int(time.wrappedValue) - tmpHours * 3600 - tmpMinutes * 60
		
		self._hours = State(initialValue: tmpHours)
		self._minutes = State(initialValue: tmpMinutes)
		self._seconds = State(initialValue: tmpSeconds)
	}
}

#Preview {
	@Previewable @State var time: Double = 24 * 3600
	
	TimePicker(time: $time)
}
