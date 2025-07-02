//
//  BabyFoodEntry.swift
//  BabyFoodTracker
//
//  Created by Sophia Tang on 7/2/25.
//

// This file defines the data model for a single food entry.

import Foundation

// Define a struct to store baby food entries
struct BabyFoodEntry: Identifiable, Codable {
    let id: UUID // Unique identifier
    var date: Date // Date and time of the food entry
    var foodContent: String // Content of the food
    var photoData: Data? // Baby's photo data (optional, stored as Data)

    // Initializer for convenience in preview and testing
    init(id: UUID = UUID(), date: Date, foodContent: String, photoData: Data? = nil) {
        self.id = id
        self.date = date
        self.foodContent = foodContent
        self.photoData = photoData
    }
}
