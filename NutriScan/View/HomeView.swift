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
            BottomButtonView(filter: .history)
                .tabItem {
                    Label("History", systemImage: "list.bullet.clipboard")
                }
            
            BarCodeScannerView()
                .environmentObject(vm)
                
                .task {
                    await vm.requestDataScannerAccessStatus()
                }// Your barcode scanner view
                .tabItem {
                    Label("Scan", systemImage: "barcode.viewfinder")
                }
            
            BottomButtonView(filter: .settings)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            
    
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
