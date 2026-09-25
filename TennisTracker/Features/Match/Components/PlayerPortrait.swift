//
//  PlayerPortrait.swift
//  TennisTracker
//
//  Editing UX reworked to be implicit rather than modal:
//  - No more separate Edit button / checkmark. Tap the name itself to
//    edit it — a small pencil hint shows it's tappable when the name
//    can be changed.
//  - Editing commits itself: it exits automatically the instant focus
//    is lost, whatever caused that (tap elsewhere, submit, keyboard
//    dismissed, match started). There's no separate "confirm" step
//    because playerName is a live binding — there's nothing to confirm.
//  - Text/TextField swap is animated so it doesn't feel like a mode
//    switch, closer to the field just becoming interactive in place.
//

import SwiftUI

struct PlayerPortrait: View {
	@Binding var stackHeight: CGFloat
	@Binding var isMatchStarted: Bool
	
	var image: String
	@Binding var playerName: String
	var defaultName: String
	@State private var isEditing: Bool = false
	@FocusState private var isNameFieldFocused: Bool
	
	var body: some View {
		VStack(spacing: 4) {
			Image(image)
				.resizable()
				.scaledToFit()
				.frame(width: 144, height: 144)
			
			Group {
				TextField("", text: $playerName)
					.focused($isNameFieldFocused)
					.font(.title3)
					.fontWeight(.semibold)
					.multilineTextAlignment(.center)
					.submitLabel(.done)
					.onSubmit { isEditing = false }
					.allowsHitTesting(isEditing)
			}
			.padding(.horizontal)
			.padding(.vertical, 8)
			.contentShape(.rect)
			.onTapGesture {
				guard !isMatchStarted else { return }
				isEditing = true
				isNameFieldFocused = true
			}
			.animation(.snappy(duration: 0.25), value: isEditing)
		}
		.background {
			GeometryReader { geo in
				Color.clear
					.onAppear { stackHeight = geo.size.height }
					.onChange(of: geo.size.height) { _, newHeight in
						stackHeight = newHeight
					}
			}
		}
		.onChange(of: isNameFieldFocused) { _, focused in
			if !focused {
				isEditing = false
			}
		}
		.onChange(of: isMatchStarted) { _, started in
			if started {
				isEditing = false
				isNameFieldFocused = false
			}
		}
	}
}
