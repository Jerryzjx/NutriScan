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
            VStack {
                
                    Chart {
                        ForEach(viewModel.nutrientIntakeByDay(nutrientType: nutrientType, items: items), id: \.date) { intake in
                            BarMark(
                                x: .value("Date", intake.date, unit: .day),
                                y: .value("Calories", intake.totalIntake)
                            )
                            .foregroundStyle(Color("EmeraldL"))
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: Calendar.Component.day)) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                        }
                    }
                    .chartYAxis {
                        AxisMarks()
                    }
                
            }
            .padding()
        }
}

