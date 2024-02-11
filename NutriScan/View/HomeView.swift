//
//  HomeView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-05.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: ScannerViewModel
    var body: some View {
        TabView {
            SummaryView()
                .tabItem {
                    Label("Summary", systemImage: "leaf.fill")
                }
            
            LogFoodView()
                .tabItem {
                    Label("Log", systemImage: "plus.app.fill")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "chart.bar.fill")
                }
            
            BottomButtonView(filter: .settings)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            
    
        }
        .accentColor(Color("EmeraldL"))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
