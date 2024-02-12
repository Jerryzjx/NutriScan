//
//  NutritionSummaryView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-12.
//

import SwiftUI

struct NutritionSummaryView: View {
    @EnvironmentObject var nutriVM: NutritionViewModel
    var nutrientType: NutrientType
    var name: String
    var body: some View {
        
        NavigationStack {
            
            List {
                VStack (alignment: .leading){
                    Text("Past 7 Days")
                        .font(.headline)
                        .fontWeight(.semibold)
                    NavigationLink (destination: DetailDailyChartView(viewModel: nutriVM, nutrientType: nutrientType, name: name)){
                        SimpleDailyChartView(viewModel: nutriVM, nutrientType: nutrientType, name: name)
                    }
                    .isDetailLink(false)
                }
                .padding(7)
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .padding(5)
                )
                
                NavigationLink (destination: DetailDailyChartView(viewModel: nutriVM, nutrientType: nutrientType, name: name)){
                        SimpleDailyChartView(viewModel: nutriVM, nutrientType: nutrientType, name: name)
                }
                .isDetailLink(false)
                .padding(7)
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .padding(5)
                )
                
            }
            .background(Color(uiColor: .systemBackground))
            .navigationTitle(name)
        }
        
    }
}
