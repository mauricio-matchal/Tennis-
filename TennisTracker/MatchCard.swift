//
//  MatchCard.swift
//  TennisTracker
//
//  Created by Mauricio Matchal on 24/08/26.
//

import Foundation
import SwiftUI

struct Match: Identifiable {
	let id = UUID()
	let opponent: String
	let score: String
	let date: String
}

let matches = [
	Match(opponent: "Alisson", score: "6–4", date: "Hoje"),
	Match(opponent: "João", score: "6–3", date: "Ontem"),
	Match(opponent: "Pedro", score: "7–5", date: "20 de ago."),
	Match(opponent: "Lucas", score: "6–2", date: "18 de ago."),
	Match(opponent: "Lucas", score: "6–2", date: "18 de ago."),
	Match(opponent: "Lucas", score: "6–2", date: "18 de ago.")
]

struct MatchCard: View {
	let match: Match
	
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
