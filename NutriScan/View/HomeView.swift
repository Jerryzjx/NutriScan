//
//  HomeView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-05.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: ScannerViewModel
    @Default(\.currentTheme) var currentTheme
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
           
                SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            
    
        }
        .accentColor(colorFromString(currentTheme))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
