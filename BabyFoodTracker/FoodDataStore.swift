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
            // Update AI analysis when entries change
            updateDietAnalysis()
        }
    }
    
    @Published var dietAnalysis: DietAnalysis?
    private let analysisService = DietAnalysisService()

    init() {
        // Load data from UserDefaults, initialize as empty array if not found
        if let savedEntries = UserDefaults.standard.data(forKey: "babyFoodEntries") {
            if let decodedEntries = try? JSONDecoder().decode([BabyFoodEntry].self, from: savedEntries) {
                self.entries = decodedEntries
                updateDietAnalysis()
                return
            }
        }
        self.entries = []
        updateDietAnalysis()
    }

    func addEntry(_ entry: BabyFoodEntry) {
        entries.append(entry)
    }

    func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
    
    func deleteEntry(withId id: UUID) {
        entries.removeAll { $0.id == id }
    }
    
    func updateEntry(_ updatedEntry: BabyFoodEntry) {
        if let index = entries.firstIndex(where: { $0.id == updatedEntry.id }) {
            entries[index] = updatedEntry
        }
    }
    
    func getEntriesForDate(_ date: Date) -> [BabyFoodEntry] {
        return entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func getEntriesForDateRange(from startDate: Date, to endDate: Date) -> [BabyFoodEntry] {
        return entries.filter { entry in
            entry.date >= startDate && entry.date <= endDate
        }
    }
    
    func getEntriesByCategory(_ category: FoodCategory) -> [BabyFoodEntry] {
        return entries.filter { $0.foodCategory == category }
    }
    
    func getTotalAmountForDate(_ date: Date) -> Double {
        let dayEntries = getEntriesForDate(date)
        return dayEntries.reduce(0) { $0 + $1.amount }
    }
    
    func getCategoryBreakdownForDate(_ date: Date) -> [FoodCategory: Int] {
        let dayEntries = getEntriesForDate(date)
        var breakdown: [FoodCategory: Int] = [:]
        
        for entry in dayEntries {
            breakdown[entry.foodCategory, default: 0] += 1
        }
        
        return breakdown
    }
    
    private func updateDietAnalysis() {
        dietAnalysis = analysisService.analyzeDiet(entries: entries)
    }
}

