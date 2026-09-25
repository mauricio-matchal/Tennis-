//
//  DebugVariablesView.swift
//  TennisTracker
//
//  Extracted from ContentView.swift. Not currently referenced anywhere —
//  kept in case you want to wire it back in for debugging match/tab state.
//

import SwiftUI

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
