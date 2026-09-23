import SwiftUI



struct MatchSheet: View {
	@Binding var isSearchSheetPresented: Bool
	@Binding var isMatchStarted: Bool
	@Binding var selectedSheetDetent: PresentationDetent
	@Binding var player1Points: Int
	@Binding var player2Points: Int
	@Binding var matchStartDate: Date?
	@Binding var isTimerActive: Bool
	
	@Namespace private var controlsAnimation
	
	@State private var isAlertPresented: Bool = false
	@State private var availableDetents: Set<PresentationDetent> = [
		.fraction(0.42)
	]
	
	@State private var isPointIncreasing: Bool = true
	@State private var player1Sets: Int = 0
	@State private var player2Sets: Int = 0
	

	var body: some View {
		NavigationStack {
			ScrollView {
				//Text("\(selectedSheetDetent)")
				//Text("\(availableDetents)")
				Spacer()
				
				MatchSheetContent(
					isSearchSheetPresented: $isSearchSheetPresented,
					isMatchStarted: $isMatchStarted,
					selectedSheetDetent: $selectedSheetDetent,
					player1Points: $player1Points,
					player2Points: $player2Points,
					player1Sets: $player1Sets,
					player2Sets: $player2Sets,
					isPointIncreasing: $isPointIncreasing,
					matchStartDate: $matchStartDate,
					isTimerActive: $isTimerActive
				)
				.padding(.horizontal, 28)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			// START BUTTON
			.safeAreaInset(edge: .bottom) {
				if !isMatchStarted {
					Button {
						availableDetents.insert(.large)
						matchStartDate = .now
						isTimerActive = true
						
						withAnimation(.spring) {
							selectedSheetDetent = .large
							isMatchStarted = true
						}
						
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
							availableDetents = [.large]
						}
					} label: {
						Label("Começar", systemImage: "play.fill")
							.labelStyle(.titleOnly)
							.font(.headline)
							.frame(maxWidth: .infinity)
							.foregroundStyle(.accentTertiary)
					}
					.buttonStyle(.glassProminent)
					.tint(.accentPrimary)
					.controlSize(.extraLarge)
					.padding(.horizontal, 24)
					.padding(.vertical, -11)
				}
			}
			.scrollDisabled(!isMatchStarted)
			.navigationTitle(isMatchStarted ? "" : "Nova partida")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				if !isMatchStarted {
					ToolbarItemGroup(placement: .topBarTrailing) {
						Button {
							isSearchSheetPresented.toggle()
						} label: {
							Label("Cancel", systemImage: "xmark")
								.labelStyle(.iconOnly)
						}
						.buttonStyle(.plain)
					}
				}
				if isMatchStarted {
					ToolbarItemGroup(placement: .principal) {
						Button {
							isSearchSheetPresented.toggle()
						} label: {
							Spacer()
							Spacer()
							Label("Minimize", systemImage: "chevron.compact.down")
								.labelStyle(.iconOnly)
								.font(.system(size: 48))
								.foregroundStyle(.secondary)
								.fontWeight(.light)
							Spacer()
							Spacer()
						}
						.buttonStyle(.glass)
					
					}
					//.sharedBackgroundVisibility(.hidden)
					
					ToolbarItemGroup(placement: .bottomBar) {
						Spacer()
						
						// PLAYER 1 BUTTONS
						
						Button {
							withAnimation(.smooth(duration: 0.3)) {
								if player1Points != 0 {
									isPointIncreasing = false
									player1Points -= 1
								}
							}
						} label: {
							Label("Subtract point", systemImage: "arrow.uturn.backward")
								.labelStyle(.iconOnly)
						}
						.disabled(player1Points == 0)
						
						Button {
							withAnimation(.smooth(duration: 0.3)) {
								if player1Points == 3 {
									player1Points = 4
								} else if player1Points < 3 {
									player1Points += 1
								}
							}
						} label: {
							Label("Add point", systemImage: "plus")
								.labelStyle(.iconOnly)
						}
						.onChange(of: player1Points) { _, newValue in
							guard newValue == 4 else { return }
							
							player1Sets += 1
							
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
								withAnimation(.smooth) {
									player1Points = 0
									player2Points = 0
								}
							}
						}
						
						Spacer()
						
						// MAIN BUTTON (START OR STOP)
						
						Button {
							isAlertPresented = true
						} label: {
							Label("Stop", systemImage: "stop.fill")
								.contentTransition(.symbolEffect(.replace))
								.labelStyle(.titleAndIcon)
						}
						.buttonStyle(.glassProminent)
						.tint(.red)
						.frame(width: 50, height: 50)
						
						Spacer()
						
						// PLAYER 2 BUTTONS
						
						Button {
							withAnimation(.smooth(duration: 0.3)) {
								if player2Points != 0 {
									isPointIncreasing = false
									player2Points -= 1
								}
							}
						} label: {
							Label("Subtract point", systemImage: "arrow.uturn.backward")
								.labelStyle(.iconOnly)
								.tint(.red)
						}
						.disabled(player2Points == 0)
						
						Button {
							withAnimation(.smooth(duration: 0.3)) {
								if player2Points == 3 {
									player2Points = 4
								} else if player2Points < 3 {
									player2Points += 1
								}
							}
						} label: {
							Label("Add point", systemImage: "plus")
								.labelStyle(.iconOnly)
						}
						.onChange(of: player2Points) { _, newValue in
							guard newValue == 4 else { return }
							
							player2Sets += 1
							
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
								withAnimation(.smooth) {
									player1Points = 0
									player2Points = 0
								}
							}
						}

						Spacer()
					}
				}
			}
		}
		.containerShape(.rect(cornerRadius: 40))
		.interactiveDismissDisabled(isMatchStarted)
		.presentationDetents(
			!isMatchStarted ? availableDetents : [.large],
			selection: $selectedSheetDetent
		)
		.presentationDragIndicator(.hidden)
		.alert("Tem certeza de que quer parar?", isPresented: $isAlertPresented) {
			Button("Cancelar", role: .cancel) { }
			
			Button("Sim", role: .destructive) {
				isSearchSheetPresented = false
				isMatchStarted = false
			}
		} message: {
			Text("A partida atual será terminada e qualquer progresso não salvo será perdido.")
		}
	}
}
