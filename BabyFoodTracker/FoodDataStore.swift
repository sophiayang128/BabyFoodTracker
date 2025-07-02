//
//  FoodDataStore.swift
//  BabyFoodTracker
//
//  Created by Sophia Tang on 7/2/25.
//

// This file handles the storage and loading of food entries.

import Foundation
import Combine // Required for @Published

// Responsible for storing and loading BabyFoodEntry data
class FoodDataStore: ObservableObject {
    @Published var entries: [BabyFoodEntry] {
        didSet {
            // Automatically save to UserDefaults when entries change
            if let encoded = try? JSONEncoder().encode(entries) {
                UserDefaults.standard.set(encoded, forKey: "babyFoodEntries")
            }
        }
    }

    init() {
        // Load data from UserDefaults, initialize as empty array if not found
        if let savedEntries = UserDefaults.standard.data(forKey: "babyFoodEntries") {
            if let decodedEntries = try? JSONDecoder().decode([BabyFoodEntry].self, from: savedEntries) {
                self.entries = decodedEntries
                return
            }
        }
        self.entries = []
    }

    func addEntry(_ entry: BabyFoodEntry) {
        entries.append(entry)
    }

    func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
}

