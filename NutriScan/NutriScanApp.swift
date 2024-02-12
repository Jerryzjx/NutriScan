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
    
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore: Bool = false
    
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
                    if hasLaunchedBefore {
                        HomeView() // Replace with your actual HomeView
                            .environmentObject(vm)
                    } else {
                        WelcomeView()
                            .environmentObject(vm)
                            .onAppear {
                                // Set the flag to true so next time the app launches, it goes directly to HomeView
                                hasLaunchedBefore = true
                            }
                    }
                }
                .modelContainer(sharedModelContainer)
            }
}
