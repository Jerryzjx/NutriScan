//
//  NutriScanApp.swift
//  NutriScan
//
//  Created by leonard on 2024-01-30.
//

import SwiftUI
import SwiftData

@main
struct NutriScanApp: App {
    
    @StateObject private var vm = ScannerViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            BarCodeScannerView()
                .environmentObject(vm)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
