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
                    Label("Home", systemImage: "house.fill")
                }
            
            ContentView()
                .tabItem {
                    Label("History", systemImage: "list.bullet.clipboard")
                }
            
            LogFoodView()
                .tabItem {
                    Label("Log", systemImage: "plus.app.fill")
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
