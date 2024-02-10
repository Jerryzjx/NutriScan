//
//  DetailChartView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-10.
//

import SwiftUI
import Charts
import SwiftData

struct NutrientIntakePerHour: Identifiable{
    let id = UUID()
    let hour: Date
    let intake: Double
}

struct DetailChartView: View {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]
    
    var nutritionType: String
    var nutriToday: Double
    var nutriUnit: String
    
    @State private var nutrientData: [NutrientIntakePerHour] = []
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4){
            
            Text("Total")
                .font(.subheadline)
                .foregroundColor(Color(uiColor: .systemGray))
                .fontWeight(.bold)
            
            HStack (alignment: .firstTextBaseline ,spacing: 2){
                Text("\(nutriToday, specifier: "%.0f")")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(nutriUnit)
                    .font(.subheadline)
                    .foregroundColor(Color(uiColor: .systemGray))
                    .fontWeight(.bold)
                
            }
            
            Text("Today")
                .font(.subheadline)
                .foregroundColor(Color(uiColor: .systemGray))
                .fontWeight(.bold)
            
            VStack {
                Chart{
                    ForEach(nutrientData) { nutrient in
                        BarMark(
                            x: .value("Hour", nutrient.hour, unit: .hour),
                            y: .value("Intake", nutrient.intake)
                        )
                        .foregroundStyle(Gradient(colors: [Color("EmeraldL"), Color("EmeraldR")]))
                    }
                    
                    
                }
                .frame(width: screenSize.width * 0.95, height: 350)
               
            }
            .onAppear {
                self.nutrientData = calculateNutrientIntakePerHour(nutritionType: self.nutritionType)
            }
        }
    }
    
    // Function to calculate nutrient (e.g., calories) intake per hour
    func calculateNutrientIntakePerHour(nutritionType: String) -> [NutrientIntakePerHour] {
        let calendar = Calendar.current
        let today = Date()
        
        // Initialize with 24 elements for each hour, with 0 intake
        var hourlyIntake: [Int: Double] = [:]
        for hour in 0..<24 {
            hourlyIntake[hour] = 0.0
        }
        
        // Filter to include only today's items
        let todayItems = items.filter { calendar.isDateInToday($0.timestamp) }
        
        // Aggregate intake by hour
        for item in todayItems {
            let hour = calendar.component(.hour, from: item.timestamp)
            let intakeValue: Double = {
                switch nutritionType {
                case "Calories":
                    return item.nfCalories ?? 0
                case "Fat":
                    return item.nfTotalFat ?? 0
                case "Carbs":
                    return item.nfTotalCarbohydrate ?? 0
                case "Protein":
                    return item.nfProtein ?? 0
                default:
                    return 0
                }
            }()
            hourlyIntake[hour, default: 0.0] += intakeValue
        }
        
        // Convert to [NutrientIntakePerHour], including hours with 0 intake
        let nutrientIntakePerHour = hourlyIntake.map { hour, intake in
            NutrientIntakePerHour(hour: calendar.date(bySettingHour: hour, minute: 0, second: 0, of: today)!, intake: intake)
        }.sorted(by: { $0.hour < $1.hour }) // Ensure the data is sorted by hour
        
        return nutrientIntakePerHour
    }
}




