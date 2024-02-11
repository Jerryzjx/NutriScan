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
    @Binding var rawSelectedHour: Date? 
    
    var selectedHour: Date? {
        guard let rawSelectedHour = rawSelectedHour else { return nil }
        
        return nutrientData.first(where: { nutrientIntake in
            Calendar.current.isDate(rawSelectedHour, equalTo: nutrientIntake.hour, toGranularity: .hour)
        })?.hour
    }
    
    var body: some View {
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
                .padding()
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
                .frame(width: screenSize.width, height: 400)
               
            }
            .onAppear {
                print(rawSelectedHour ?? "No selection yet")
                self.nutrientData = calculateNutrientIntakePerHour(nutritionType: self.nutritionType)
            }
            
                
            
            
            
            Spacer()
        }
        
        .padding()
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




