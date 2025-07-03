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
    var foodName: String // Name of the food (from library or custom)
    var foodCategory: FoodCategory // Category of food for better organization
    var amount: Double // Amount of food in grams or ml
    var amountUnit: AmountUnit // Unit of measurement
    var isFromLibrary: Bool // Whether food was selected from library
    var photoData: Data? // Baby's photo data (optional, stored as Data)
    var notes: String? // Additional notes (optional)

    // Initializer for convenience in preview and testing
    init(id: UUID = UUID(), 
         date: Date, 
         foodName: String, 
         foodCategory: FoodCategory = .other,
         amount: Double = 0.0,
         amountUnit: AmountUnit = .ounces,
         isFromLibrary: Bool = false,
         photoData: Data? = nil,
         notes: String? = nil) {
        self.id = id
        self.date = date
        self.foodName = foodName
        self.foodCategory = foodCategory
        self.amount = amount
        self.amountUnit = amountUnit
        self.isFromLibrary = isFromLibrary
        self.photoData = photoData
        self.notes = notes
    }
}

// Food categories for better organization and AI analysis
enum FoodCategory: String, CaseIterable, Codable {
    case fruits = "Fruits"
    case vegetables = "Vegetables"
    case grains = "Grains"
    case proteins = "Proteins"
    case dairy = "Dairy"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .fruits: return "🍎"
        case .vegetables: return "🥕"
        case .grains: return "🌾"
        case .proteins: return "🥩"
        case .dairy: return "🥛"
        case .other: return "🍽️"
        }
    }
    
    var color: String {
        switch self {
        case .fruits: return "red"
        case .vegetables: return "green"
        case .grains: return "yellow"
        case .proteins: return "orange"
        case .dairy: return "blue"
        case .other: return "gray"
        }
    }
}

// Units for food amount measurement
enum AmountUnit: String, CaseIterable, Codable {
    case ounces = "oz"
    case grams = "g"
    case milliliters = "ml"
    case tablespoons = "tbsp"
    case teaspoons = "tsp"
    case cups = "cups"
    case pieces = "pieces"
    
    var displayName: String {
        switch self {
        case .ounces: return "ounces"
        case .grams: return "grams"
        case .milliliters: return "ml"
        case .tablespoons: return "tablespoons"
        case .teaspoons: return "teaspoons"
        case .cups: return "cups"
        case .pieces: return "pieces"
        }
    }
}

// Food library item for predefined baby foods
struct FoodLibraryItem: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let category: FoodCategory
    let recommendedAge: String // e.g., "6-8 months"
    let description: String
    let nutritionalInfo: String?
    
    init(id: UUID = UUID(), name: String, category: FoodCategory, recommendedAge: String, description: String, nutritionalInfo: String? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.recommendedAge = recommendedAge
        self.description = description
        self.nutritionalInfo = nutritionalInfo
    }
}
