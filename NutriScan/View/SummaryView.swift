//
//  SummaryView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-09.
//

import SwiftUI
import HealthKit
import SwiftData

struct WaveShapeSummary: Shape {
    
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
struct SummaryView: View {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    @StateObject var healthKitManager = HealthKitManager.shared
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]
    
    // This property aggregates today's nutritional data
    private var todaysNutrition: (calories: Double, fat: Double, carbs: Double, protein: Double) {
        let calendar = Calendar.current
        let todayItems = items.filter { calendar.isDateInToday($0.timestamp) }
        
        let totalCalories = todayItems.compactMap { $0.nfCalories }.reduce(0, +)
        let totalFat = todayItems.compactMap { $0.nfTotalFat }.reduce(0, +)
        let totalCarbs = todayItems.compactMap { $0.nfTotalCarbohydrate }.reduce(0, +)
        let totalProtein = todayItems.compactMap { $0.nfProtein }.reduce(0, +)
        return (totalCalories, totalFat, totalCarbs, totalProtein)
    }
    
    
    var body: some View {
        NavigationStack {
            
                ZStack{
                    VStack(alignment: .center){
                        ZStack {
                            WaveShapeSummary()
                                .fill(Color("EmeraldL"))
                                .opacity(0.4)
                                .frame(height: 170)
                                .shadow(color: .black, radius: 2, x: 0.0, y: 0.0)
                            
                            WaveShapeSummary()
                                .fill(Color("EmeraldL"))
                                .opacity(0.75)
                                .frame(height: 170)
                                .offset(x: 0, y: -20.0)
                                .shadow(color: .black, radius: 4, x: 0.0, y: 0.0)
                        }
                     //   .ignoresSafeArea()
                        Spacer()
                        Spacer()
                        ScrollView{
                        VStack (alignment: .leading, spacing: 2){
                            
                            HStack {
                                Image(systemName: "carrot.fill")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("EmeraldL"))
                                Text("Calories")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                            HStack {
                                Spacer()
                                Spacer()
                                VStack(spacing: 3){
                                    
                                    Text("\(todaysNutrition.calories, specifier: "%.0f") Cal")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Text("Cal intake")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Rectangle() // This acts as the horizontal line
                                        .frame(height: 1) // Set the height to 1 to make it a thin line
                                        .foregroundColor(Color(uiColor: .systemGray3)) // Set the color of the line
                                        .padding(.horizontal, 10) // Optional: add some horizontal padding
                                    
                                    Text("\(NutritionConstants.calories, specifier: "%.0f") Cal")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Text("Goal")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Rectangle() // This acts as the horizontal line
                                        .frame(height: 1) // Set the height to 1 to make it a thin line
                                        .foregroundColor(Color(uiColor: .systemGray3)) // Set the color of the line
                                        .padding(.horizontal, 10) // Optional: add some horizontal padding
                                    
                                    Text("271")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Text("Active Cal")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                }
                                Spacer()
                                nutriRingView(ringWidth: 18.7, pct: (todaysNutrition.calories/NutritionConstants.calories) * 100.00, dimension: 120, bgColor: Color("EmeraldL"), fgColors: [Color("EmeraldL"), Color("EmeraldR")])
                                Spacer()
                                Spacer()
                            }
                        }
                        .frame(maxWidth: screenSize.width * 0.85)
                        .padding(7)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                            
                        )
                        
                        Spacer()
                        
                            nutriDisplayView(name: "Protein", nutriToday: todaysNutrition.protein, nutriConst: NutritionConstants.protein, bgColor: Color("SeashoreL"), fgColors: [Color("SeashoreL"), Color("SeashoreR")])
                        
                        Spacer()
                            
                            nutriDisplayView(name: "Carbs", nutriToday: todaysNutrition.carbs, nutriConst: NutritionConstants.carbs, bgColor: Color("SeashoreL"), fgColors: [Color("SeashoreL"), Color("SeashoreR")])
                        
                        Spacer()
                            
                            nutriDisplayView(name: "Fat", nutriToday: todaysNutrition.fat, nutriConst: NutritionConstants.fat, bgColor: Color("SeashoreL"), fgColors: [Color("SeashoreL"), Color("SeashoreR")])
                        
                        Spacer()
                            Spacer()
                    }
                    
                }
                
                
            }
                .navigationTitle("Summary")
                .ignoresSafeArea()
            
        }
    }
    
    private func nutriRingView(ringWidth: Double, pct: Double, dimension: Double, bgColor: Color, fgColors:[Color]) -> some View{
        return HStack (alignment: .center){
            RingView(ringWidth: ringWidth, percent: pct, backgroundColor: bgColor.opacity(0.33), foregroundColors: fgColors)
                .frame(width: dimension, height: dimension)
                .padding()
        }
        
    }
    
    private func nutriDisplayView(name: String, nutriToday: Double, nutriConst: Double, bgColor: Color, fgColors: [Color]) -> some View {
        return VStack (alignment: .leading, spacing: 2){
            HStack {
                Image(systemName: "carrot.fill")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(bgColor)
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            } .foregroundColor(.primary)
            
            HStack {
                Spacer()
                Spacer()
                VStack(spacing: 3){
                    
                    Text("\(nutriToday, specifier: "%.0f") g")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("\(name) intake")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(uiColor: .systemGray3))
                    
                    Text("\(nutriConst, specifier: "%.0f") g")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Goal")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                }
                Spacer()
                nutriRingView(ringWidth: 18.7, pct: (nutriToday/nutriConst) * 100.00, dimension: 120, bgColor: bgColor, fgColors: fgColors)
                Spacer()
                Spacer()
            }
        }
        .frame(maxWidth: screenSize.width * 0.85)
        .padding(7)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
            
        )
    }
}

#Preview {
    SummaryView()
}
