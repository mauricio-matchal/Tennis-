//
//  RecentMatchCard.swift
//  TennisTracker
//
//  Moved from MatchCard.swift. Renamed Match -> RecentMatch and
//  MatchCard -> RecentMatchCard so this mock-data type doesn't collide
//  with the SwiftData `Match` model once it's added under Models/.
//
//  Created by Mauricio Matchal on 24/08/26.
//

import Foundation
import SwiftUI

struct RecentMatch: Identifiable {
	let id = UUID()
	let opponent: String
	let score: String
	let date: String
}

let recentMatches = [
	RecentMatch(opponent: "Alisson", score: "6–4", date: "Hoje"),
	RecentMatch(opponent: "João", score: "6–3", date: "Ontem"),
	RecentMatch(opponent: "Pedro", score: "7–5", date: "20 de ago."),
	RecentMatch(opponent: "Lucas", score: "6–2", date: "18 de ago."),
	RecentMatch(opponent: "Lucas", score: "6–2", date: "18 de ago."),
	RecentMatch(opponent: "Lucas", score: "6–2", date: "18 de ago.")
]

struct RecentMatchCard: View {
	let match: RecentMatch
	
	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 4) {
				Text("Maurício vs. \(match.opponent)")
					.font(.headline)
				
				Text(match.date)
					.font(.subheadline)
					.foregroundStyle(.secondary)
			}
			
			Spacer()
			
			Text(match.score)
				.font(.title3)
				.fontWeight(.semibold)
		}
		.padding()
		.frame(maxWidth: .infinity)
		.background(.regularMaterial)
		.glassEffect(in: .rect(cornerRadius: 16.0))
		.clipShape(RoundedRectangle(cornerRadius: 16))
	}
}
