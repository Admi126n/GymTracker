//
//  TimePickerSheet.swift
//  GymTracker
//
//  Created by Adam Tokarski on 10/03/2025.
//

import SwiftUI

struct TimePickerSheet: View {
	
	@Binding var value: TimeInterval
	
	@Environment(\.dismiss) var dismiss
	
	@State private var sheetHeight: CGFloat = .zero
	
	var body: some View {
		NavigationStack {
			TimePicker(time: $value)
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Button("Done") {
							dismiss()
						}
						.tint(.green)
					}
				}
		}
		.presentationDetents([.fraction(0.33)])
	}
}

#Preview {
	@Previewable @State var value: TimeInterval = 0
	
	TimePickerSheet(value: $value)
}
