//
//  ContentView.swift
//  edfadsf
//
//  Created by Mauricio Matchal on 23/07/26.
//

import SwiftUI

private let tennisScore: [Int: String] = [
	0: "0",
	1: "15",
	2: "30",
	3: "40",
	4: "Set!"
]

enum TabSelection: String {
	case home
	case court
	case settings
	case startMatch
}

struct DebugVariablesView: View {
	let selectedSheetDetent: PresentationDetent
	let selectedTab: TabSelection
	let isMatchStarted: Bool
	let isSearchSheetPresented: Bool
	
	var body: some View {
		List {
			Section("Variables") {
				LabeledContent("selectedSheetDetent") {
					Text("")
						.monospaced()
				}
				
				LabeledContent("selectedTab") {
					Text(selectedTab.rawValue)
				}
				
				LabeledContent("isMatchStarted") {
					Text(isMatchStarted ? "true" : "false")
						.monospaced()
				}
				
				LabeledContent("isSearchSheetPresented") {
					Text(isSearchSheetPresented ? "true" : "false")
						.monospaced()
				}
			}
		}
		.scrollContentBackground(.hidden)
		.listRowBackground(Color.clear)
	}
}

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

struct ContentView: View {
	@State private var selectedTab: TabSelection = .home
	@State private var isSearchSheetPresented = false
	@State private var isMatchStarted = false
	@State private var selectedSheetDetent = PresentationDetent.medium
	@State private var player1Points: Int = 0
	@State private var player2Points: Int = 0
	@Namespace private var sheetPresentation
	@State private var matchStartDate: Date? = .now
	@State private var isTimerActive: Bool = false
	
	private func abbreviatedName(from name: String) -> String {
		let nameParts = name.split(separator: " ")
		guard let firstName = nameParts.first else { return name }
		guard let lastInitial = nameParts.last?.first, nameParts.count > 1 else {
			return String(firstName)
		}
		
		return "\(firstName) \(lastInitial)"
	}
	
	private var tabSelection: Binding<TabSelection> {
		Binding(
			get: { selectedTab },
			set: { newValue in
				if newValue == .startMatch {
					isMatchStarted = false
					selectedSheetDetent = .medium
					isSearchSheetPresented = true
				} else {
					selectedTab = newValue
				}
			}
		)
	}
	
	var body: some View {
		ZStack {
			
			NavigationStack {
				ScrollView {
					VStack(alignment: .leading, spacing: 12) {
						Text("Recentes")
							.font(.headline)
							.foregroundStyle(.secondary)
							.padding(.top)
							.padding(.horizontal, 12)
						
						VStack{
							ForEach(matches) { match in MatchCard(match: match) }
						}
						
						Text("Resumos")
							.font(.headline)
							.foregroundStyle(.secondary)
							.padding(.top)
							.padding(.horizontal, 12)
					}
					.frame(maxWidth: .infinity, alignment: .leading)
				}
				.scrollEdgeEffectStyle(.soft, for: .top)
				.safeAreaPadding(.horizontal)
				.scrollContentBackground(.hidden)
				.background(
						LinearGradient(
							stops: [
								Gradient.Stop(color: Color.accentSecondary.opacity(0.6), location: 0),
								Gradient.Stop(color: Color.accentSecondary.opacity(0.25), location: 0.35),
								Gradient.Stop(color: Color.accentSecondary.opacity(0.25), location: 1)
							],
							startPoint: .top,
							endPoint: .bottom
						)
						.ignoresSafeArea()
				)
				.navigationTitle("Partidas")
				.toolbar {
					if isMatchStarted {
						ToolbarItem (placement: .bottomBar) {
							HStack(spacing: 2) {
								HStack(alignment: .center, spacing: 12) {
									Text(tennisScore[player1Points] ?? String(player1Points))
										.fontWeight(.semibold)
										.fontWidth(.compressed)
										.font(.title)
										.foregroundStyle(player1Points > player2Points ? .accentPrimary : .primary)
									/*Image("portraitPlayer1")
										.resizable()
										.scaledToFit()
										.frame(width: 40, height: 40)
										.padding(.top, 2)*/
									Text("Maurício")
										.font(.title3)
										.fontWidth(.condensed)
										.foregroundStyle(.secondary)
										.tracking(0.4)
										.fontWeight(.medium)
									Spacer()
								}
								
								if let startDate = matchStartDate {
									Text(startDate, style: .timer)
										.font(.title)
										.fontWeight(.bold)
										//.monospacedDigit()
										.fontWidth(.compressed)
								}
								
								
								HStack(alignment: .center, spacing: 12) {
									Spacer()
									Text("Alisson")
										.font(.title3)
										.fontWidth(.condensed)
										.foregroundStyle(.secondary)
										.tracking(0.4)
										.fontWeight(.medium)
									/*Image("portraitPlayer2")
										.resizable()
										.scaledToFit()
										.frame(width: 40, height: 40)
										.padding(.top, 2)*/
									Text(tennisScore[player2Points] ?? String(player2Points))
										.fontWeight(.semibold)
										.fontWidth(.compressed)
										.font(.title)
										.foregroundStyle(player2Points > player1Points ? .accentPrimary : .primary)
								}
							}
							.frame(maxWidth: .infinity)
							.padding(.horizontal, 18)
							.padding(.vertical, 7)
							.contentShape(.capsule)
							.onTapGesture { isSearchSheetPresented = true }
							.matchedTransitionSource(id: "sheet", in: sheetPresentation)
						}
					} else {
						ToolbarItemGroup(placement: .bottomBar) {
							Spacer()
							Button {
								isMatchStarted = false
								selectedSheetDetent = .medium
								isSearchSheetPresented = true
							} label: {
								Label("Começar partida", systemImage: "figure.tennis")
									.labelStyle(.automatic)
									.font(.title3)
									.fontWeight(.medium)
									.offset(x: -1)
									.frame(width: 60, height: 60)
							}
							.clipShape(.circle)
							.buttonStyle(.plain)
							.matchedTransitionSource(id: "sheet", in: sheetPresentation)
						}
					}
				}
			}
		}
		.tabViewBottomAccessory(isEnabled: isMatchStarted) {
			Button () {
				isSearchSheetPresented = true
			} label: {
				MatchAccessory(
					player1Points: player1Points,
					player2Points: player2Points,
					matchStartDate: matchStartDate
				)
			}
			.buttonStyle(.plain)
		}
		.tabBarMinimizeBehavior(.onScrollDown)
		.tint(.accentPrimary)
		.sheet(isPresented: $isSearchSheetPresented) {
			MatchSheet(
				isSearchSheetPresented: $isSearchSheetPresented,
				isMatchStarted: $isMatchStarted,
				selectedSheetDetent: $selectedSheetDetent,
				player1Points: $player1Points,
				player2Points: $player2Points,
				matchStartDate: $matchStartDate,
				isTimerActive: $isTimerActive
			)
			.navigationTransition(.zoom(sourceID: "sheet", in: sheetPresentation))
		}
	}
}

#Preview {
	ContentView()
}
