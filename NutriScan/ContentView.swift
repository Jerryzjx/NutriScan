//
//  ContentView.swift
//  NutriScan
//
//  Created by leonard on 2024-01-30.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                            .font(.custom("Geist-Regular", size: 20))
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
                .font(.custom("GeistVariable-Regular", size: 20))
        }
    }
    /*
     Font: Geist Variable ["GeistVariable-Regular", "GeistVariable-UltraLight", "GeistVariable-Light", "GeistVariable-Medium", "GeistVariable-SemiBold", "GeistVariable-Bold", "GeistVariable-Black", "GeistVariable-UltraBlack"]
     */
    
    // Get our font name
    /*
    init() {
        for familyName in UIFont.familyNames.sorted() {
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        }
    }
     */

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
