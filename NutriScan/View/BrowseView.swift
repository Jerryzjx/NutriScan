//
//  BrowseView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-10.
//

import SwiftUI
import SwiftData

struct Nutrient: Identifiable {
    let id = UUID()
    let name: String
    let type: NutrientType
    let symbolName: String
}

// Sample Nutrients
let nutrientlist = [
    Nutrient(name: "Calories", type: .calories, symbolName: "flame.fill"),
    Nutrient(name: "Protein", type: .protein, symbolName: "fish.fill"),
    Nutrient(name: "Carbohydrates", type: .carbohydrates, symbolName: "carrot.fill"),
    Nutrient(name: "Sugar", type: .sugar, symbolName: "carrot.fill"),
    Nutrient(name: "Fiber", type: .fiber, symbolName: "carrot.fill"),
    Nutrient(name: "Fats", type: .fats, symbolName: "carrot.fill"),
    Nutrient(name: "Saturated Fats", type: .saturatedFats, symbolName: "carrot.fill")
]

struct BrowseView: View {
    // Using sample data for demonstration
    let nutrients: [Nutrient] = nutrientlist
    @EnvironmentObject var nutriVM: NutritionViewModel
    
    var body: some View {
        NavigationStack {
            List(nutrients) { nutrient in
                NavigationLink(destination: NutritionSummaryView(nutrientType: nutrient.type, name: nutrient.name).environmentObject(nutriVM)) {
                                Label(nutrient.name, systemImage: nutrient.symbolName)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                            }.isDetailLink(false)
                        }
            .navigationTitle("Nutrient Categories")
        }
    }
        
    }

