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
    Nutrient(name: "Saturated Fats", type: .saturatedFats, symbolName: "carrot.fill"),
    Nutrient(name: "Sodium", type: .sodium, symbolName: "carrot.fill"),
    Nutrient(name: "Cholesterol", type: .cholesterol, symbolName: "carrot.fill")
]

struct WaveShapeBrowse: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start at the top left corner
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        // Draw a line to the bottom left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        // Draw a line to the bottom right corner, slightly above the bottom edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 50))
        // Draw a line back to the top right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        // Move back to the bottom left corner to start the curve
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // Add a curve to the bottom right corner, slightly above the bottom edge
        // Adjust control points to bring the curve's center more towards the center
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - 50),
                      control1: CGPoint(x: rect.minX + rect.width * 0.35, y: rect.maxY + rect.height * 0.22), // Control point 1 moved towards center
                      control2: CGPoint(x: rect.maxX - rect.width * 0.35, y: rect.maxY + rect.height * 0.22)) // Control point 2 mirrored
        
        return path
    }
    
}

struct BrowseView: View {
    // Using sample data for demonstration
    let nutrients: [Nutrient] = nutrientlist
    @EnvironmentObject var nutriVM: NutritionViewModel
    @Default(\.currentTheme) var currentTheme
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack {
                    
                    WaveShapeSettings()
                        .fill(colorFromString(currentTheme))
                        .opacity(0.4)
                        .frame(height: 170)
                        .shadow(color: .black, radius: 2, x: 0.0, y: 0.0)
                    
                    WaveShapeSettings()
                        .fill(colorFromString(currentTheme))
                        .opacity(0.75)
                        .frame(height: 170)
                        .offset(x: 0, y: -20.0)
                        .shadow(color: .black, radius: 4, x: 0.0, y: 0.0)
                }
                
                
                //   .ignoresSafeArea()
                Spacer()
                Spacer()
                List(nutrients) { nutrient in
                    NavigationLink(destination: NutritionSummaryView(nutrientType: nutrient.type, name: nutrient.name).environmentObject(nutriVM)) {
                        Label(nutrient.name, systemImage: nutrient.symbolName)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                    }.isDetailLink(false)
                }
            }
            .ignoresSafeArea()
            .navigationTitle("Nutrient Categories")
        }
    }
        
    }

