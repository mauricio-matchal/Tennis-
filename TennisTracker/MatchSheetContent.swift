	//
	//  MatchSheetContent.swift
	//  edfadsf
	//
	//  Created by Mauricio Matchal on 30/07/26.
	//
	import SwiftUI

	private let tennisScore: [Int: String] = [
		0: "0",
		1: "15",
		2: "30",
		3: "40",
		4: "Set!"
	]

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
		
		@State private var stackHeight: CGFloat = 0
		
		let font = UIFont.systemFont(ofSize: 24)
		
		private func abbreviatedName(from name: String) -> String {
			let nameParts = name.split(separator: " ")
			guard let firstName = nameParts.first else { return name }
			guard let lastInitial = nameParts.last?.first,
				  nameParts.count > 1 else {
				return String(firstName)
			}
			
			return "\(firstName) \(lastInitial)"
		}
		
		
		var player1: String = "Maurício Matchal Pinheiro Passos"
		var player2: String = "Alisson Reinan Lima da Silva"
		
		@State var player1Name: String = ""
		@State var player2Name: String = ""
		
		var body: some View {
			VStack(alignment: .center, spacing: 8) {
				
				if let startDate = matchStartDate {
					if isMatchStarted && isTimerActive {
						Text(startDate, style: .timer)
							.font(.largeTitle)
							.fontWeight(.semibold)
							.fontWidth(.compressed)
					}
				}
				
				HStack(alignment: .top) {
					VStack(alignment: .center, spacing: 24) {
						PlayerPortrait(stackHeight: $stackHeight, isMatchStarted: $isMatchStarted, player: player1, image: "portraitPlayer1", playerName: player1Name)

						if isMatchStarted {
							Text(tennisScore[player1Points] ?? String(player1Points))
								.font(.system(size: 100))
								.fontWidth(.compressed)
								.fontWeight(.medium)
								.fixedSize(horizontal: true, vertical: false)
								.foregroundStyle(player1Points == 0 ? .tertiary : .primary)
								.rotationEffect(player1Points == 4 ? .degrees(-10) : .degrees(0))
								.contentTransition(.numericText(countsDown: !isPointIncreasing))
							Text("Sets: \(player1Sets)")
						}
					}
					.frame(maxWidth: .infinity)
					
					Spacer()
					
					Text("vs")
						.font(.title)
						.fontWeight(.medium)
						.fontWidth(.condensed)
						.foregroundStyle(.secondary)
						.padding(.top, (stackHeight/2) - 28)
					
					Spacer()
					
					VStack(alignment: .center, spacing: 24) {
						PlayerPortrait(stackHeight: $stackHeight, isMatchStarted: $isMatchStarted, player: player2, image: "portraitPlayer2", playerName: player2Name)

						if isMatchStarted {
							Text(tennisScore[player2Points] ?? String(player2Points))
								.font(.system(size: 100))
								.fontWidth(.compressed)
								.fontWeight(.medium)
								.fixedSize(horizontal: true, vertical: false)
								.foregroundStyle(player2Points == 0 ? .tertiary : .primary)
								.rotationEffect(player2Points == 4 ? .degrees(-10) : .degrees(0))
								.contentTransition(.numericText(countsDown: !isPointIncreasing))
							Text("Sets: \(player2Sets)")
						}
					}
					.frame(maxWidth: .infinity)
				}
			}
		}
	}
