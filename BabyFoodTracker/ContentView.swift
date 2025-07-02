//
//  ContentView.swift
//  BabyFoodTracker
//
//  Created by Sophia Tang on 7/2/25.
//
// This is the main view that organizes the different tabs.

import SwiftUI

// The main entry point of the App, using TabView to organize different functional modules
struct ContentView: View {
    // Use @StateObject to manage data, ensuring data persists throughout the view's lifecycle
    @StateObject var foodStore = FoodDataStore()

    var body: some View {
        // TabView for switching between different functional modules
        TabView {
            // First Tab: Add Food Entry
            AddEntryView(foodStore: foodStore)
                .tabItem {
                    Label("Add Entry", systemImage: "plus.circle.fill")
                }

            // Second Tab: View Food History
            HistoryView(foodStore: foodStore)
                .tabItem {
                    Label("History", systemImage: "calendar")
                }

            // Third Tab: Food Recommendations
            RecommendationsView()
                .tabItem {
                    Label("Recommendations", systemImage: "lightbulb.fill")
                }
        }
        // Set overall UI style to be simple and cute
        .accentColor(.pink) // Accent color for cute icons and selected items
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(foodStore: FoodDataStore())
    }
}
