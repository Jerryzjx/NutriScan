//
//  DailyChartView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-12.
//

import SwiftUI
import SwiftData
import Charts

struct DailyChartView: View {
    @ObservedObject var viewModel: NutritionViewModel
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]
    var nutrientType: NutrientType
    var name: String
    
    var body: some View {
            let today = Calendar.current.startOfDay(for: Date())

            VStack {
                Chart {
                    ForEach(viewModel.nutrientIntakeByHour(nutrientType: nutrientType, items: items, forDay: today), id: \.hour) { intake in
                        BarMark(
                            x: .value("Hour", intake.hour),
                            y: .value(name, intake.totalIntake) // Using 'name' for dynamic nutrient type
                        )
                        .foregroundStyle(Color("EmeraldL"))
                    }
                }
            }
            .padding()
        }
    }

