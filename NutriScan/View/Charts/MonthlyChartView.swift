//
//  MonthlyChartView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-12.
//

import SwiftUI
import SwiftData
import Charts

struct MonthlyChartView: View {
    @ObservedObject var viewModel: NutritionViewModel
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]
    var nutrientType: NutrientType
    let screenSize = UIScreen.main.bounds.size
    var name: String
    
    var body: some View {
        VStack {
            Chart {
                ForEach(viewModel.nutrientIntakeByMonth(nutrientType: nutrientType, items: items), id: \.month) { intake in
                    BarMark(
                        x: .value("Month", intake.month),
                        y: .value("Average Intake", intake.averageDailyIntake)
                    )
                    .foregroundStyle(Color("EmeraldL"))
                }
            }
            
            .chartXAxis {
                AxisMarks(values: .stride(by: Calendar.Component.month)) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                }
            }
            .chartYAxis {
                AxisMarks()
            }
        }
        .padding()
    }
}
