//
//  MatchSheetContent.swift
//  TennisTracker
//
//  Changes in this pass:
//  - Player names are now a single source of truth (player1Name/player2Name),
//    passed to PlayerPortrait as a Binding, so edits actually take effect
//    instead of dying inside PlayerPortrait's own local @State.
//  - Blank-name fallback now lives in PlayerPortrait (fires on commit,
//    not per keystroke) — this file just supplies each player's default
//    name via `defaultName`.
//  - Removed dead code: the unused `abbreviatedName` helper, the unused
//    `font` constant, and the fake full legal names that were never
//    actually displayed anywhere.
//  - "vs" vertical alignment no longer depends on a GeometryReader round-trip
//    through `stackHeight`; it's computed from the known portrait size, which
//    is simpler and doesn't silently break if spacing above the image changes.
//  - Sets count is now a small pill instead of a plain Text, consistent
//    with the rest of the app's glass/rounded visual language.
//  - Player column markup (portrait + score + sets) was duplicated for
//    player 1 and player 2; factored into one `playerColumn` builder.
//

import SwiftUI

struct MatchSheetContent: View {
	@Binding var isSearchSheetPresented: Bool
	@Binding var isMatchStarted: Bool
	@Binding var selectedSheetDetent: PresentationDetent
	@Binding var player1Points: Int
	@Binding var player2Points: Int
	@Binding var player1Sets: Int
	@Binding var player2Sets: Int
	@Binding var isPointIncreasing: Bool
	@Binding var matchStartDate: Date?
	@Binding var isTimerActive: Bool
	
	/// Known size of PlayerPortrait's image, used to vertically center "vs"
	/// without needing a GeometryReader round-trip.
	private let portraitImageSize: CGFloat = 144
	
	@State private var stackHeight: CGFloat = 0
	@State private var player1Name: String = "Jogador 1"
	@State private var player2Name: String = "Jogador 2"
	
	var body: some View {
		VStack(alignment: .center, spacing: 20) {
			
			if let startDate = matchStartDate, isMatchStarted, isTimerActive {
				Text(startDate, style: .timer)
					.font(.system(size: 72))
					.fontWeight(.semibold)
					.fontWidth(.compressed)
					.padding(.top, 8)
			}
			
			HStack(alignment: .top) {
				playerColumn(
					name: $player1Name,
					defaultName: "Jogador 1",
					image: "portraitPlayer1",
					points: player1Points,
					sets: player1Sets
				)
				.frame(maxWidth: .infinity)
				
				Spacer()
				
				Text("vs")
					.font(.title)
					.fontWeight(.medium)
					.fontWidth(.condensed)
					.foregroundStyle(.secondary)
					.padding(.top, portraitImageSize / 2 - 14)
				
				Spacer()
				
				playerColumn(
					name: $player2Name,
					defaultName: "Jogador 2",
					image: "portraitPlayer2",
					points: player2Points,
					sets: player2Sets
				)
				.frame(maxWidth: .infinity)
			}
		}
	}
	
	@ViewBuilder
	private func playerColumn(
		name: Binding<String>,
		defaultName: String,
		image: String,
		points: Int,
		sets: Int
	) -> some View {
		VStack(alignment: .center, spacing: 24) {
			PlayerPortrait(
				stackHeight: $stackHeight,
				isMatchStarted: $isMatchStarted,
				image: image,
				playerName: name,
				defaultName: defaultName
			)
			
			if isMatchStarted {
				Text(tennisScore[points] ?? String(points))
					.font(.system(size: 100))
					.fontWidth(.compressed)
					.fontWeight(.medium)
					.fixedSize(horizontal: true, vertical: false)
					.foregroundStyle(points == 0 ? .tertiary : .primary)
					.rotationEffect(points == 4 ? .degrees(-10) : .degrees(0))
					.contentTransition(.numericText(countsDown: !isPointIncreasing))
				
				Text("Sets: \(sets)")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundStyle(.secondary)
					.padding(.horizontal, 10)
					.padding(.vertical, 4)
					.background(.regularMaterial, in: .capsule)
			}
		}
	}
}
