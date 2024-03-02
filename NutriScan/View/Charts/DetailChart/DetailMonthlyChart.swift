//
//  DetailMonthlyChart.swift
//  NutriScan
//
//  Created by leonard on 2024-02-12.
//

import SwiftUI
import Charts
import SwiftData

struct DetailMonthlyChart: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]
    @ObservedObject var vm: NutritionViewModel
    @Default(\.currentTheme) var currentTheme

    var name: String
    let screenSize = UIScreen.main.bounds.size
    
    @Binding var rawSelectedDate: Date?
    
    var selectedDate: Date? {
        guard let rawSelectedDate = rawSelectedDate else { return nil }

        // Find the first NutrientIntakePerDay where the day matches rawSelectedDate
        return nutrientData.first { nutrientIntake in
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: nutrientIntake.day)
        }?.day
    }
    
    var unit: String {
            switch nutrientType {
            case .calories:
                return "kcal"
            case .sodium, .cholesterol:
                return "mg"
            default:
                return "g"
            }
        }
    
    private var nutrientData: [NutrientIntakePerDay] {
        calculateNutrientIntakePerDay(nutritionType: name)
    }
    
    private func calculateNutrientIntakePerDay(nutritionType: String) -> [NutrientIntakePerDay] {
        let calendar = Calendar.current
        var last30DaysIntake: [Date: Double] = [:]

        for dayOffset in -29...0 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: calendar.startOfDay(for: Date())) {
                last30DaysIntake[date] = 0.0
            }
        }
        
        items.forEach { item in
            let itemDate = calendar.startOfDay(for: item.timestamp)
            if let _ = last30DaysIntake[itemDate] {
                let intakeValue: Double = {
                    switch name {
                    case "Calories":
                        return item.nfCalories ?? 0
                    case "Fats":
                        return item.nfTotalFat ?? 0
                    case "Carbohydrates":
                        return item.nfTotalCarbohydrate ?? 0
                    case "Protein":
                        return item.nfProtein ?? 0
                    case "Saturated Fats":
                        return item.nfSaturatedFat ?? 0
                    case "Fiber":
                        return item.nfDietaryFiber ?? 0
                    case "Sugar":
                        return item.nfSugars ?? 0
                    case "Sodium":
                        return item.nfSodium ?? 0
                    case "Cholesterol":
                        return item.nfCholesterol ?? 0
                    default:
                        return 0
                    }
                }()
                last30DaysIntake[itemDate, default: 0.0] += intakeValue
            }
        }

        // Convert to [NutrientIntakePerDay]
        return last30DaysIntake.map { NutrientIntakePerDay(day: $0.key, intake: $0.value) }.sorted(by: { $0.day < $1.day })
    }
    
    var description: String {
        switch name {
        case "Calories":
            return "Calories provide energy that the body needs to function. They're a measure of energy expenditure and are essential for maintaining bodily functions and for fueling physical activities."
        case "Carbohydrates":
            return "Carbohydrates are the body's main energy source. They break down into glucose, which can be used immediately for energy or stored in the liver and muscles for later use."
        case "Fats":
            return "Fats are a necessary part of the diet, providing essential fatty acids, contributing to the absorption of certain vitamins, and are a major energy source for the body."
        case "Protein":
            return "Protein is crucial for the building and repair of body tissues. It's a major component of every cell in the body and is also used to make enzymes, hormones, and other body chemicals."
        default:
            return "Unknown nutrition type."
        }
    }
    
  var dailyValueDescription: String {
        switch name {
        case "Calories":
            return "An ideal daily intake of calories varies depending on age, metabolism and levels of physical activity, among other things. Generally, the recommended daily calorie intake is 2,000 calories a day for women and 2,500 for men. (Source: NHS)"
        case "Carbohydrates":
            return "The daily value for sugars is 100 grams for adults and children 4 years of age or older."
        case "Fats":
            return "The daily value for fats is 75 grams for adults and children 4 years of age or older."
        case "Protein":
            return "There is no % Daily Value (% DV) for protein in the Nutrition Facts table. This is because most people get enough protein, so it is not a health concern for Canadians who eat a mixed diet."
        default:
            return "Unknown nutrition type."
        }
    }
    var nutrientType: NutrientType
   
    
    var body: some View {
        let nutriThisMonth = vm.averageIntakePastMonth(nutrientType: nutrientType, items: items)
        ScrollView {
            VStack (alignment: .leading, spacing: 4){
                
                VStack (alignment: .leading, spacing: 2){
                    
                    Text("Average")
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .systemGray))
                        .fontWeight(.bold)
                        .opacity(rawSelectedDate == nil ? 1 : 0)
                    
                    HStack (alignment: .firstTextBaseline ,spacing: 4){
                        Text("\(nutriThisMonth, specifier: "%.0f")")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .opacity(rawSelectedDate == nil ? 1 : 0)
                        
                        Text(unit)
                            .font(.subheadline)
                            .foregroundColor(Color(uiColor: .systemGray))
                            .fontWeight(.bold)
                            .opacity(rawSelectedDate == nil ? 1 : 0)
                        
                    }
                    
                    Text("This Month")
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .systemGray))
                        .fontWeight(.bold)
                        .opacity(rawSelectedDate == nil ? 1 : 0)
                    
                }
                .padding(.vertical, 5)
                .frame(height: 75)
            VStack {
                Chart {
                    ForEach(nutrientData) { dataPoint in
                        BarMark(
                            x: .value("Day", dataPoint.day, unit: .day),
                            y: .value("Intake", dataPoint.intake)
                        )
                        .foregroundStyle(colorFromString(currentTheme))
                    }
                
                if let selectedDate {
                    RuleMark(
                        x: .value("Selected", selectedDate, unit: .day)
                    )
                    .foregroundStyle(Color.gray.opacity(0.3))
                    .offset(x: 0, yStart: -5)
                    .zIndex(-1)
                    .annotation(
                        position: .top, spacing: 1,
                        overflowResolution: .init(
                            x: .fit(to: .chart),
                            y: .disabled
                        )
                    ) {
                        valueSelectionPopover
                    }
                }
                
            }
            .chartXSelection(value: $rawSelectedDate)
            .frame(width: screenSize.width * 0.95, height: 240)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                // Title and Summary
                VStack(alignment: .leading, spacing: 4) {
                    Text("About \(name)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(3)
                    
                    Text(description)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.regularMaterial))
                        
                }
                .padding()
               
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Suggested Daily Value")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(3)
                    
                    Text(dailyValueDescription)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.regularMaterial))
                      
                    Link("Learn more at Canada.ca", destination: URL(string: "https://www.canada.ca/en/health-canada/services/technical-documents-labelling-requirements/table-daily-values/nutrition-labelling.html")!)
                            .font(.footnote)
                            .foregroundColor(.blue)
                }
                .padding()
                
            }
            .background(Color(uiColor: .secondarySystemBackground))
            
        }
        .navigationTitle("\(name)").navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}
        
    var valueSelectionPopover: some View {
        // Adjusted to work with `selectedDate` and daily granularity
        guard let selectedDate = selectedDate,
              let nutrientIntake = nutrientData.first(where: { Calendar.current.isDate($0.day, inSameDayAs: selectedDate) }) else {
            return AnyView(EmptyView()) // Return an empty view if no selection is made
        }
        return AnyView(
            VStack(alignment: .leading, spacing: 2) {
                Text("Total")
                    .font(.subheadline)
                    .foregroundColor(Color(uiColor: .systemGray))
                    .fontWeight(.bold)
                
                HStack(alignment: .firstTextBaseline, spacing: 4){
                    Text("\(nutrientIntake.intake, specifier: "%.0f")")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(unit) // Ensure `nutriUnit` is defined in your context
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .systemGray))
                        .fontWeight(.bold)
                }
                Text("\(selectedDate, formatter: dayFormatter)") // Use `dayFormatter` to format the date
                    .font(.subheadline)
                    .foregroundColor(Color(uiColor: .systemGray))
                    .fontWeight(.bold)
            }
                .padding(6)
                .frame(minWidth: 100, maxHeight: 75)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.125)))
                .zIndex(0)
        )
    }

    // Helper formatter for displaying the day
    var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Adjusted to show a more complete date
        formatter.timeStyle = .none
        return formatter
    }
}
