//
//  RecommendationsView.swift
//  BabyFoodTracker
//
//  Created by Sophia Tang on 7/2/25.
//

// This file defines the view for displaying food recommendations.

import SwiftUI

struct RecommendationsView: View {
    @ObservedObject var foodStore: FoodDataStore
    @StateObject private var foodLibrary = FoodLibrary()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Header with cute styling
                    VStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.yellow)
                            .padding(.bottom, 5)
                        
                        Text("Food Recommendations")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Expert tips for your baby's nutrition! 🥕")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // AI Analysis Section
                    if let analysis = foodStore.dietAnalysis {
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.purple)
                                    .font(.title2)
                                Text("AI Diet Analysis")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            
                            DietAnalysisCard(analysis: analysis)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .purple.opacity(0.2), radius: 10, x: 0, y: 5)
                        )
                    }
                    
                    // Personalized Recommendations
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .foregroundColor(.green)
                                .font(.title2)
                            Text("Personalized Recommendations")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        PersonalizedRecommendationsCard(
                            foodStore: foodStore,
                            foodLibrary: foodLibrary
                        )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .green.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                    
                    // Age-based recommendations
                    VStack(spacing: 20) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .foregroundColor(.blue)
                                .font(.title2)
                            Text("Age-Based Guidelines")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        // 6-8 Months Card
                        RecommendationCard(
                            ageRange: "6-8 Months",
                            icon: "baby.fill",
                            color: .blue,
                            recommendations: [
                                "Rice cereal",
                                "Vegetable purees (carrots, pumpkin)",
                                "Fruit purees (apples, bananas)",
                                "Start with single-ingredient foods"
                            ]
                        )
                        
                        // 8-10 Months Card
                        RecommendationCard(
                            ageRange: "8-10 Months",
                            icon: "baby.fill",
                            color: .orange,
                            recommendations: [
                                "Meat purees (chicken, fish)",
                                "Egg yolk",
                                "Soft noodles",
                                "Small fruit pieces"
                            ]
                        )
                        
                        // 10-12 Months Card
                        RecommendationCard(
                            ageRange: "10-12 Months",
                            icon: "baby.fill",
                            color: .green,
                            recommendations: [
                                "Finger foods",
                                "Soft cooked vegetables",
                                "Small pieces of meat",
                                "Whole grain cereals"
                            ]
                        )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .blue.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                }
                .padding(.horizontal, 20)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.yellow.opacity(0.05), Color.green.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationBarHidden(true)
        }
    }
}

struct DietAnalysisCard: View {
    let analysis: DietAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Summary stats
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(analysis.totalEntries)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Total Entries")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(format: "%.1f", analysis.averageDailyIntake))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Avg Daily Intake")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Category breakdown
            if !analysis.categoryBreakdown.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Diet Breakdown:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(Array(analysis.categoryBreakdown.keys), id: \.self) { category in
                            HStack {
                                Text(category.icon)
                                Text(category.rawValue)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(analysis.categoryBreakdown[category] ?? 0)")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.1))
                            )
                        }
                    }
                }
            }
            
            // Recommendations
            if !analysis.recommendations.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("AI Recommendations:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    ForEach(analysis.recommendations, id: \.self) { recommendation in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                                .padding(.top, 2)
                            
                            Text(recommendation)
                                .font(.caption)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                    }
                }
            }
            
            // Insights
            if !analysis.nutritionalInsights.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nutritional Insights:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    ForEach(analysis.nutritionalInsights, id: \.self) { insight in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .foregroundColor(.green)
                                .font(.caption)
                                .padding(.top, 2)
                            
                            Text(insight)
                                .font(.caption)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.purple.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct PersonalizedRecommendationsCard: View {
    @ObservedObject var foodStore: FoodDataStore
    @ObservedObject var foodLibrary: FoodLibrary
    
    private var missingCategories: [FoodCategory] {
        let usedCategories = Set(foodStore.entries.map { $0.foodCategory })
        return FoodCategory.allCases.filter { !usedCategories.contains($0) }
    }
    
    private var recommendedFoods: [FoodLibraryItem] {
        var recommendations: [FoodLibraryItem] = []
        
        // Add foods from missing categories
        for category in missingCategories.prefix(3) {
            let categoryFoods = foodLibrary.getFoodsByCategory(category)
            if let firstFood = categoryFoods.first {
                recommendations.append(firstFood)
            }
        }
        
        // If we have enough variety, suggest based on most consumed category
        if missingCategories.isEmpty, let analysis = foodStore.dietAnalysis {
            if let mostEaten = analysis.categoryBreakdown.max(by: { $0.value < $1.value }) {
                let categoryFoods = foodLibrary.getFoodsByCategory(mostEaten.key)
                recommendations.append(contentsOf: categoryFoods.prefix(2))
            }
        }
        
        return Array(recommendations.prefix(4))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 10) {
            Image(systemName: "star.circle")
                .font(.system(size: 50))
                .foregroundColor(.green.opacity(0.6))
            
            Text("Great variety!")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text("You're already feeding your baby a diverse diet. Keep it up!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.green.opacity(0.1))
                .stroke(Color.green.opacity(0.3), lineWidth: 2)
        )
    }
    
    private var recommendationsGridView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Try These Foods:")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(recommendedFoods) { food in
                    FoodRecommendationCard(food: food)
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if recommendedFoods.isEmpty {
                emptyStateView
            } else {
                recommendationsGridView
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.green.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct FoodRecommendationCard: View {
    let food: FoodLibraryItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(food.category.icon)
                    .font(.title3)
                Text(food.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
            
            Text(food.description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            Text(food.recommendedAge)
                .font(.caption2)
                .foregroundColor(.blue)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue.opacity(0.1))
                )
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct RecommendationCard: View {
    let ageRange: String
    let icon: String
    let color: Color
    let recommendations: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                
                Text(ageRange)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(recommendations, id: \.self) { recommendation in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(color)
                            .font(.caption)
                            .padding(.top, 2)
                        
                        Text(recommendation)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct RecommendationsView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationsView(foodStore: FoodDataStore())
    }
}
