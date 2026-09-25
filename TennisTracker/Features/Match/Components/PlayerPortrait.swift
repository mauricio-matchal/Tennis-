//
//  PlayerPortrait.swift
//  TennisTracker
//
//  Extracted from MatchSheetContent.swift.
//

import SwiftUI

struct PlayerPortrait: View {
	@Binding var stackHeight: CGFloat
	@Binding var isMatchStarted: Bool
	
	var player: String
	var image: String
	@State var playerName: String
	@State var isEditing: Bool = false
	
	func getFirstName(from fullName: String) -> String {
		// Splits by spaces and takes the first word found
		return fullName.split(separator: " ").first?.description ?? fullName + "M."
	}
	
	var body: some View {
		VStack(spacing: 4) {
			Image(image)
				.resizable()
				.scaledToFit()
				.frame(width: 144, height: 144)
			HStack {
				if (!isEditing) {
					Text(getFirstName(from: player))
						.font(.title3)
						.fontWeight(.semibold)
						.multilineTextAlignment(.center)
					if(!isMatchStarted) {
						Button {
							isEditing = true
						} label: {
							Label("Edit", systemImage: "pencil")
								.labelStyle(.iconOnly)
								.tint(.orange)
								.font(.title3)
						}
					}
				} else {
					TextField("\(getFirstName(from: player))", text: $playerName)
						.background(playerName.isEmpty ? AnyShapeStyle(Color.gray.opacity(0.1)) : AnyShapeStyle(Color.clear))
						.cornerRadius(12)
						.font(.title3)
						.fontWeight(.semibold)
						.multilineTextAlignment(.center)
						.allowsHitTesting(!isMatchStarted)
				}
			}
			.padding(.horizontal)
			.padding(.vertical, 8)
		}
		.background {
			GeometryReader { geo in
				Color.clear
					.onAppear {
						stackHeight = geo.size.height
					}
					.onChange(of: geo.size.height) { _, newHeight in
						stackHeight = newHeight
					}
			}
		}
	}
}
