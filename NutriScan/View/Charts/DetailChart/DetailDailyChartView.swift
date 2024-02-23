//
//  DetailChartView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-10.
//

import SwiftUI
import Charts
import SwiftData



struct DetailDailyChartView: View {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]
    
    var nutritionType: String
    var nutrientType: NutrientType
    var nutriToday: Double
    var nutriUnit: String {
        switch nutrientType {
        case .calories:
            return "kcal"
        case .sodium, .cholesterol:
            return "mg"
        default:
            return "g"
        }
    }
    @State private var nutrientData: [NutrientIntakePerHour] = []
    @Binding var rawSelectedHour: Date?
    
    var selectedHour: Date? {
        guard let rawSelectedHour = rawSelectedHour else { return nil }
        
        return nutrientData.first(where: { nutrientIntake in
            Calendar.current.isDate(rawSelectedHour, equalTo: nutrientIntake.hour, toGranularity: .hour)
        })?.hour
    }
    
    var description: String {
        switch nutritionType {
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
        switch nutritionType {
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

    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 4){
                
                VStack (alignment: .leading, spacing: 2){
                    
                    Text("Total")
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .systemGray))
                        .fontWeight(.bold)
                        .opacity(rawSelectedHour == nil ? 1 : 0)
                    
                    HStack (alignment: .firstTextBaseline ,spacing: 4){
                        Text("\(nutriToday, specifier: "%.0f")")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .opacity(rawSelectedHour == nil ? 1 : 0)
                        
                        Text(nutriUnit)
                            .font(.subheadline)
                            .foregroundColor(Color(uiColor: .systemGray))
                            .fontWeight(.bold)
                            .opacity(rawSelectedHour == nil ? 1 : 0)
                        
                    }
                    
                    Text("Today")
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .systemGray))
                        .fontWeight(.bold)
                        .opacity(rawSelectedHour == nil ? 1 : 0)
                    
                }
                .padding(.vertical, 5)
                .frame(height: 75)
                VStack {
                    Chart{
                        ForEach(nutrientData) { nutrient in
                            BarMark(
                                x: .value("Hour", nutrient.hour, unit: .hour),
                                y: .value("Intake", nutrient.intake)
                            )
                            .foregroundStyle(Gradient(colors: [Color("EmeraldL"), Color("EmeraldR")]))
                            
                        }
                        
                        if let selectedHour {
                            RuleMark(
                                x: .value("Selected", selectedHour, unit: .hour)
                            )
                            .foregroundStyle(Color.gray.opacity(0.3))
                            .offset(yStart: -5)
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
                    .chartXSelection(value: $rawSelectedHour)
                    .frame(width: screenSize.width * 0.95, height: 240)
                    
                }
                .onAppear {
                    print(rawSelectedHour ?? "No selection yet")
                    self.nutrientData = calculateNutrientIntakePerHour(nutritionType: self.nutritionType)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and Summary
                    VStack(alignment: .leading, spacing: 4) {
                        Text("About \(nutritionType)")
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
            .navigationTitle("\(nutritionType)").navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
        
        var valueSelectionPopover: some View {
            guard let selectedHour = selectedHour,
                  let nutrientIntake = nutrientData.first(where: { Calendar.current.isDate($0.hour, equalTo: selectedHour, toGranularity: .hour) }) else {
                return AnyView(EmptyView()) // Return an empty view if no selection is made
            }
            return AnyView(
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total")
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .systemGray))
                        .fontWeight(.bold)
                    
                    HStack (alignment: .firstTextBaseline ,spacing: 4){
                        Text("\(nutrientIntake.intake, specifier: "%.0f")")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(nutriUnit)
                            .font(.subheadline)
                            .foregroundColor(Color(uiColor: .systemGray))
                            .fontWeight(.bold)
                        
                    }
                    Text("\(selectedHour, formatter: hourFormatter) - \(selectedHour.addingTimeInterval(3600), formatter: hourFormatter)")
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .systemGray))
                        .fontWeight(.bold)
                }
                    .padding(6)
                    .frame(minWidth: 100, maxHeight:75)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.125)))
                    .zIndex(0)
            )
        }
        
        // Helper formatter for displaying the hour
        var hourFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "ha"
            return formatter
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
                hourlyIntake[hour, default: 0.0] += intakeValue
            }
            
            // Convert to [NutrientIntakePerHour], including hours with 0 intake
            let nutrientIntakePerHour = hourlyIntake.map { hour, intake in
                NutrientIntakePerHour(hour: calendar.date(bySettingHour: hour, minute: 0, second: 0, of: today)!, intake: intake)
            }.sorted(by: { $0.hour < $1.hour }) // Ensure the data is sorted by hour
            
            return nutrientIntakePerHour
        }
    }
    
    
    
    
