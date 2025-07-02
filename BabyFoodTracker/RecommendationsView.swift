//
//  RecommendationsView.swift
//  BabyFoodTracker
//
//  Created by Sophia Tang on 7/2/25.
//

// This file defines the view for displaying food recommendations.

import SwiftUI

struct RecommendationsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Monthly Food Recommendations (To be implemented)")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.gray)

                // Placeholder for age-based recommendation content
                // Example:
                Text("6-8 Months Baby Food Recommendations:")
                    .font(.title2)
                    .padding(.bottom, 5)
                Text("Rice cereal, vegetable purees (carrots, pumpkin), fruit purees (apples, bananas).")
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                Text("\n8-10 Months Baby Food Recommendations:")
                    .font(.title2)
                    .padding(.bottom, 5)
                Text("Meat purees (chicken, fish), egg yolk, soft noodles, small fruit pieces.")
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .navigationTitle("Food Recommendations")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecommendationsView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationsView()
    }
}
