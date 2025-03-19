//
//  SwipableView.swift
//  GymTracker
//
//  Created by Adam Tokarski on 19/03/2025.
//

import SwiftUI

struct SwipableView<Content: View>: View {
	
	@State private var offset: CGFloat = 0
	@State private var startOffset: CGFloat = 0
	@State private var isDraggind = false
	@State private var isTriggered = false
	
	private let triggerThreshold: CGFloat = -250
	private let expansionThreshold: CGFloat = -60
	
	private let content: Content
	private let actions: [SwipableViewAction]
	private let cornerRadius: CGFloat
	
	private var expansionOffset: CGFloat {
		CGFloat(actions.count) * -50
	}
	
	private var dragGesture: some Gesture {
		DragGesture()
			.onChanged(onGestureChanged)
			.onEnded(onGestureEnded)
	}
	
	var body: some View {
		content
			.padding(.vertical, 4)
			.offset(x: offset)
			.frame(maxWidth: .infinity, alignment: .leading)
			.contentShape(.rect)
			.overlay(alignment: .trailing) {
				ZStack(alignment: .trailing) {
					ForEach(Array(actions.enumerated()), id: \.offset) { index, action in
						let proportion = CGFloat(actions.count - index)
						let isDefault = index == actions.count - 1
						
						let width = isDefault && isTriggered ? -offset : -offset * proportion / CGFloat(actions.count)
						
						ActionButton(action: action, width: width) {
							withAnimation {
								offset = 0
							}
						}
					}
				}
				.animation(.spring, value: isTriggered)
				.onChange(of: isTriggered) { _, newValue in
					if newValue {
						UIImpactFeedbackGenerator(style: .medium).impactOccurred()
					}
				}
			}
			.clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
			.highPriorityGesture(dragGesture)
	}
	
	init(cornerRadius: CGFloat = 10, actions: [SwipableViewAction], @ViewBuilder content: () -> Content) {
		self.cornerRadius = cornerRadius
		self.actions = actions
		self.content = content()
	}
	
	init(cornerRadius: CGFloat = 10, action: SwipableViewAction, @ViewBuilder content: () -> Content) {
		self.cornerRadius = cornerRadius
		self.actions = [action]
		self.content = content()
	}
	
	private func onGestureChanged(_ value: DragGesture.Value) {
		guard !actions.isEmpty else { return }
		
		if !isDraggind {
			startOffset = offset
			isDraggind = true
		}
		
		withAnimation(.interactiveSpring) {
			offset = min(startOffset + value.translation.width, 0)
		}
		
		isTriggered = offset < triggerThreshold
	}
	
	private func onGestureEnded(_ value: DragGesture.Value) {
		withAnimation {
			isDraggind = false
			
			if value.predictedEndTranslation.width < expansionThreshold && !isTriggered {
				offset = expansionOffset
			} else {
				if let action = actions.last, isTriggered {
					action.action()
				}
				
				offset = 0
			}
			
			isTriggered = false
		}
	}
}

private struct ActionButton: View {
	
	let action: SwipableViewAction
	let width: CGFloat
	let onDismiss: () -> Void
	
	var body: some View {
		Button {
			action.action()
			onDismiss()
		} label: {
			action.color
				.overlay(alignment: .leading) {
					Label(action.name, systemImage: action.systemIcon)
						.labelStyle(.iconOnly)
						.padding(.leading)
						.foregroundStyle(.white)
				}
				.clipped()
				.frame(width: width)
		}
		.buttonStyle(.plain)
	}
}

struct SwipableViewAction {
	let color: Color
	let name: String
	let systemIcon: String
	let action: () -> Void
	
	static func delete(action: @escaping () -> Void) -> SwipableViewAction {
		.init(color: .red, name: "trash", systemIcon: "trash.fill", action: action)
	}
}

#Preview {
	SwipableView(action: .init(color: .red, name: "trash", systemIcon: "trash.fill", action: { })) {
		Text("Swipe me!")
	}
}
