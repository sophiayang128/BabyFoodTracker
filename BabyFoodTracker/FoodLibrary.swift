//
//  FoodLibrary.swift
//  BabyFoodTracker
//
//  Created by Sophia Tang on 7/2/25.
//

// This file manages the food library and provides food recommendations.

import Foundation

class FoodLibrary: ObservableObject {
    @Published var foodItems: [FoodLibraryItem] = []
    
    init() {
        loadFoodLibrary()
    }
    
    private func loadFoodLibrary() {
        // 6-8 Months Foods
        let sixToEightMonths = [
            FoodLibraryItem(name: "Rice Cereal", category: .grains, recommendedAge: "6-8 months", description: "Iron-fortified rice cereal mixed with breast milk or formula", nutritionalInfo: "Iron, B vitamins"),
            FoodLibraryItem(name: "Apple Puree", category: .fruits, recommendedAge: "6-8 months", description: "Smooth apple puree, great first fruit", nutritionalInfo: "Vitamin C, fiber"),
            FoodLibraryItem(name: "Banana Puree", category: .fruits, recommendedAge: "6-8 months", description: "Naturally sweet and easy to digest", nutritionalInfo: "Potassium, vitamin B6"),
            FoodLibraryItem(name: "Carrot Puree", category: .vegetables, recommendedAge: "6-8 months", description: "Sweet and nutritious first vegetable", nutritionalInfo: "Vitamin A, beta-carotene"),
            FoodLibraryItem(name: "Sweet Potato Puree", category: .vegetables, recommendedAge: "6-8 months", description: "Naturally sweet and rich in nutrients", nutritionalInfo: "Vitamin A, fiber"),
            FoodLibraryItem(name: "Avocado Puree", category: .fruits, recommendedAge: "6-8 months", description: "Healthy fats and creamy texture", nutritionalInfo: "Healthy fats, vitamin E")
        ]
        
        // 8-10 Months Foods
        let eightToTenMonths = [
            FoodLibraryItem(name: "Chicken Puree", category: .proteins, recommendedAge: "8-10 months", description: "Lean protein source for growing babies", nutritionalInfo: "Protein, iron, zinc"),
            FoodLibraryItem(name: "Salmon Puree", category: .proteins, recommendedAge: "8-10 months", description: "Omega-3 fatty acids for brain development", nutritionalInfo: "Omega-3, protein, vitamin D"),
            FoodLibraryItem(name: "Egg Yolk", category: .proteins, recommendedAge: "8-10 months", description: "Rich in choline and healthy fats", nutritionalInfo: "Choline, vitamin D, healthy fats"),
            FoodLibraryItem(name: "Pea Puree", category: .vegetables, recommendedAge: "8-10 months", description: "Good source of protein and fiber", nutritionalInfo: "Protein, fiber, vitamin C"),
            FoodLibraryItem(name: "Pear Puree", category: .fruits, recommendedAge: "8-10 months", description: "Gentle on tummy and naturally sweet", nutritionalInfo: "Fiber, vitamin C"),
            FoodLibraryItem(name: "Oatmeal", category: .grains, recommendedAge: "8-10 months", description: "Whole grain goodness for energy", nutritionalInfo: "Fiber, iron, B vitamins")
        ]
        
        // 10-12 Months Foods
        let tenToTwelveMonths = [
            FoodLibraryItem(name: "Soft Cooked Vegetables", category: .vegetables, recommendedAge: "10-12 months", description: "Small pieces of soft-cooked vegetables", nutritionalInfo: "Various vitamins and minerals"),
            FoodLibraryItem(name: "Finger Foods", category: .other, recommendedAge: "10-12 months", description: "Small, soft pieces for self-feeding", nutritionalInfo: "Develops motor skills"),
            FoodLibraryItem(name: "Yogurt", category: .dairy, recommendedAge: "10-12 months", description: "Plain yogurt with live cultures", nutritionalInfo: "Calcium, protein, probiotics"),
            FoodLibraryItem(name: "Cheese", category: .dairy, recommendedAge: "10-12 months", description: "Small pieces of soft cheese", nutritionalInfo: "Calcium, protein"),
            FoodLibraryItem(name: "Whole Grain Bread", category: .grains, recommendedAge: "10-12 months", description: "Small pieces of soft whole grain bread", nutritionalInfo: "Fiber, B vitamins"),
            FoodLibraryItem(name: "Soft Fruits", category: .fruits, recommendedAge: "10-12 months", description: "Small pieces of soft fruits", nutritionalInfo: "Various vitamins and antioxidants")
        ]
        
        foodItems = sixToEightMonths + eightToTenMonths + tenToTwelveMonths
    }
    
    func getFoodsForAge(_ ageRange: String) -> [FoodLibraryItem] {
        return foodItems.filter { $0.recommendedAge == ageRange }
    }
    
    func getFoodsByCategory(_ category: FoodCategory) -> [FoodLibraryItem] {
        return foodItems.filter { $0.category == category }
    }
    
    func searchFoods(_ query: String) -> [FoodLibraryItem] {
        let lowercasedQuery = query.lowercased()
        return foodItems.filter { 
            $0.name.lowercased().contains(lowercasedQuery) ||
            $0.description.lowercased().contains(lowercasedQuery)
        }
    }
}

// AI Analysis Service for diet analysis
class DietAnalysisService: ObservableObject {
    @Published var analysisResults: DietAnalysis?
    
    func analyzeDiet(entries: [BabyFoodEntry]) -> DietAnalysis {
        let totalEntries = entries.count
        guard totalEntries > 0 else {
            return DietAnalysis(
                totalEntries: 0,
                categoryBreakdown: [:],
                averageDailyIntake: 0,
                recommendations: ["Start adding food entries to get personalized recommendations!"],
                nutritionalInsights: []
            )
        }
        
        // Calculate category breakdown
        var categoryCount: [FoodCategory: Int] = [:]
        var totalAmount: Double = 0
        
        for entry in entries {
            categoryCount[entry.foodCategory, default: 0] += 1
            totalAmount += entry.amount
        }
        
        // Calculate average daily intake (assuming entries are from last 7 days)
        let lastWeekEntries = entries.filter { 
            Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.contains($0.date) ?? false 
        }
        let averageDailyIntake = lastWeekEntries.isEmpty ? 0 : totalAmount / 7
        
        // Generate recommendations
        var recommendations: [String] = []
        
        if categoryCount[.vegetables] == nil || categoryCount[.vegetables]! < 2 {
            recommendations.append("Try adding more vegetables to ensure balanced nutrition")
        }
        
        if categoryCount[.fruits] == nil || categoryCount[.fruits]! < 2 {
            recommendations.append("Include more fruits for vitamins and natural sweetness")
        }
        
        if categoryCount[.proteins] == nil || categoryCount[.proteins]! < 1 {
            recommendations.append("Add protein sources for healthy growth and development")
        }
        
        if averageDailyIntake < 50 {
            recommendations.append("Consider increasing portion sizes gradually")
        }
        
        // Generate nutritional insights
        var insights: [String] = []
        if let mostEaten = categoryCount.max(by: { $0.value < $1.value }) {
            insights.append("Most consumed category: \(mostEaten.key.rawValue)")
        }
        
        if categoryCount.count >= 4 {
            insights.append("Great variety in food categories!")
        } else {
            insights.append("Try introducing foods from different categories")
        }
        
        return DietAnalysis(
            totalEntries: totalEntries,
            categoryBreakdown: categoryCount,
            averageDailyIntake: averageDailyIntake,
            recommendations: recommendations,
            nutritionalInsights: insights
        )
    }
}

struct DietAnalysis {
    let totalEntries: Int
    let categoryBreakdown: [FoodCategory: Int]
    let averageDailyIntake: Double
    let recommendations: [String]
    let nutritionalInsights: [String]
} 