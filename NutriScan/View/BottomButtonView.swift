//
//  BottomButtonView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-05.
//

import SwiftUI

struct BottomButtonView: View {
    enum BottomButton {
        case history
        case settings
    }
    
    let filter: BottomButton
    
    var title: String {
        switch filter {
        case.history:
            return "History"
        case.settings:
            return "Settings"
        }
    }
    
    var body: some View {
        
           NavigationStack {
               switch filter {
               case .history:
                   Text("History View") // Replace with your history view
                       .navigationTitle("History")
                   
               case .settings:
                   Text("Settings View") // Replace with your settings view
                       .navigationTitle("Settings")
               }
           }
       }
}

#Preview {
    BottomButtonView(filter: .history)
}
