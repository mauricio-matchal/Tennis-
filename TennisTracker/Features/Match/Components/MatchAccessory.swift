//
//  MatchAccessory.swift
//  TennisTracker
//
//  Extracted from ContentView.swift — the tab-bar bottom accessory shown
//  while a match is in progress.
//

import SwiftUI

struct MatchAccessory: View {
	@Environment(\.tabViewBottomAccessoryPlacement)
	private var placement
	
	let player1Points: Int
	let player2Points: Int
	let matchStartDate: Date?
	
	var body: some View {
		switch placement {
		case .inline:
			HStack(spacing: 8) {
				Text(tennisScore[player1Points] ?? String(player1Points))
					.fontWeight(.semibold)
					.fontWidth(.compressed)
					.font(.title)
					.foregroundStyle(player1Points > player2Points ? .accentPrimary : .primary)
				Text("M")
					.font(.title3)
					.fontWidth(.condensed)
					.fontWeight(.semibold)
					.foregroundStyle(.secondary)
				Spacer()
				if let startDate = matchStartDate {
					Text(startDate, style: .timer)
						.font(.title)
						.fontWeight(.semibold)
						.fontWidth(.compressed)
				}
				Spacer()
				Text("A")
					.font(.title3)
					.fontWidth(.condensed)
					.fontWeight(.semibold)
					.foregroundStyle(.secondary)
				Text(tennisScore[player2Points] ?? String(player2Points))
					.fontWeight(.semibold)
					.fontWidth(.compressed)
					.font(.title)
					.foregroundStyle(player2Points > player1Points ? .accentPrimary : .primary)
			}
			.padding(.horizontal, 18)
			
		case .expanded:
			HStack(spacing: 0) {
				Text(tennisScore[player1Points] ?? String(player1Points))
					.fontWeight(.semibold)
					.fontWidth(.compressed)
					.font(.title)
					.foregroundStyle(player1Points > player2Points ? .accentPrimary : .primary)
				Image("portraitPlayer1")
					.resizable()
					.scaledToFit()
					.frame(width: 44, height: 44)
					.padding(.top, 4)
				Text("Maurício")
					.font(.headline)
					.fontWidth(.condensed)
					.foregroundStyle(.secondary)
					.tracking(0.4)
				
				
				Spacer()
				if let startDate = matchStartDate {
					Text(startDate, style: .timer)
						.font(.title)
						.fontWeight(.semibold)
						.fontWidth(.compressed)
				}
				Spacer()
				
				Text("Alisson")
					.font(.headline)
					.fontWidth(.condensed)
					.foregroundStyle(.secondary)
					.tracking(0.4)
				Image("portraitPlayer2")
					.resizable()
					.scaledToFit()
					.frame(width: 44, height: 44)
					.padding(.top, 4)
				Text(tennisScore[player2Points] ?? String(player2Points))
					.fontWeight(.semibold)
					.fontWidth(.compressed)
					.font(.title)
					.foregroundStyle(player2Points > player1Points ? .accentPrimary : .primary)
			}
			.padding(.horizontal, 16)
		default:
			EmptyView()
		}
	}
}
