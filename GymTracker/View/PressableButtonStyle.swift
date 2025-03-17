//
//  PressableButtonStyle.swift
//  GymTracker
//
//  Created by Adam Tokarski on 13/03/2025.
//

import SwiftUI

struct Pressable<S: ShapeStyle>: ButtonStyle {
	
	let background: Color
	let foreground: S
	
	var cornerRadius: CGFloat = 10
	var borderWidth: CGFloat = 4
	
	func makeBody(configuration: Configuration) -> some View {
		PrivateButton(
			configuration: configuration,
			background: background,
			foreground: foreground,
			cornerRadius: cornerRadius,
			borderWidth: borderWidth)
	}
	
	private struct PrivateButton: View {
		
		@Environment(\.isEnabled) private var isEnabled: Bool
		
		let configuration: ButtonStyle.Configuration
		let background: Color
		let foreground: S
		
		var cornerRadius: CGFloat = 10
		var borderWidth: CGFloat = 4
		
		var body: some View {
			configuration.label
				.bold()
				.padding(8)
				.background(background.mix(with: .gray, by: isEnabled ? 0 : 0.5))
				.foregroundStyle(foreground)
				.clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
				.offset(y: configuration.isPressed ? borderWidth : 0)
				.background(
					RoundedRectangle(cornerRadius: cornerRadius)
						.fill(background.mix(with: .black, by: isEnabled ? 0.3 : 0.4))
						.cornerRadius(cornerRadius)
						.offset(y: borderWidth)
				)
				.animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
		}
	}
}

#Preview {
	Button("Press me") { }
		.buttonStyle(Pressable(background: .green, foreground: .background))
}
