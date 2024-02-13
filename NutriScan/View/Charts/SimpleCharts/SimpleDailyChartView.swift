//
//  SimpleDailyChartView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-12.
//

import SwiftUI
import SwiftData

struct SimpleDailyChartView: View {
    @ObservedObject var viewModel: NutritionViewModel
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]
    var nutrientType: NutrientType
    var name: String
   
    
    var unit: String {
            switch nutrientType {
            case .calories:
                return "kcal"
            default:
                return "g"
            }
        }
    
    var body: some View {
        VStack (alignment: .leading){
            
           
            let todayIntakeTotal = viewModel.totalIntakeToday(nutrientType: nutrientType, items: items)
            Text("Total")
                .font(.headline)
            HStack (alignment: .firstTextBaseline){
                Text("\(todayIntakeTotal, specifier: "%.0f")")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(unit)
                    .font(.subheadline)
                    .foregroundColor(Color(uiColor: .systemGray))
                    .fontWeight(.bold)
                
            }
            
            VStack (alignment: .trailing){
                DailyChartView(viewModel: viewModel, nutrientType: nutrientType, name: name)
                    .frame(height: 100)
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
            }
        }
    }
}

