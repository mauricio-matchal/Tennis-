//
//  HomeView.swift
//  TennisTracker
//
//  Renamed from ContentView.swift — this is the "Home" screen from the
//  planning doc (recent matches, start-match entry point).
//
//  Created by Mauricio Matchal on 23/07/26.
//

import SwiftUI

enum TabSelection: String {
	case home
	case court
	case settings
	case startMatch
}

struct HomeView: View {
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
							ForEach(recentMatches) { match in RecentMatchCard(match: match) }
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
	HomeView()
}
