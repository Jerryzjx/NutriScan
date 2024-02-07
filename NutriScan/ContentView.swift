//
//  ContentView.swift
//  NutriScan
//
//  Created by leonard on 2024-01-30.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]

    var body: some View {
        VStack(alignment: .leading){
            Text("Scanned History")
                .font(.largeTitle)
                .fontWeight(.bold)
            NavigationSplitView {
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            ItemDetailView(for: item)
                            
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.foodName) // Display the food name
                                    .font(.headline)
                                Text(item.brandName ?? "") // Display the brand name
                                    .font(.subheadline)
                                    .foregroundColor(.gray) // Optional: Make the brand name less prominent
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            } detail: {
                Text("Select an item")
            }
        }
        .padding()
    }
    /*
     Font: Geist Variable ["GeistVariable-Regular", "GeistVariable-UltraLight", "GeistVariable-Light", 
     "GeistVariable-Medium", "GeistVariable-SemiBold", "GeistVariable-Bold", "GeistVariable-Black", "GeistVariable-UltraBlack"]
     */
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func ItemDetailView(for foodItem: Item) -> some View {
        
        return ScrollView {
            // Check if there is at least one item in itemDetails
                VStack(alignment: .leading, spacing: 15) {
                    // Directly use foodItem since we're guaranteed to only have one
                    VStack (alignment: .center, spacing: 15){
                        Text(foodItem.foodName)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(foodItem.brandName ?? "")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Nutritional Value:")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        HStack {
                            // squared display for more important nutritional values
                            // Fix the width and height of each VStack
                            Spacer()
                            // display for Calories
                            if let nfCalories = foodItem.nfCalories {
                                    ValueView(label: "Cal", value: "\(Int(nfCalories))")
                                }
                            
                            Spacer()
                            // display for Fat
                            if let nfTotalFat = foodItem.nfTotalFat {
                                    ValueView(label: "Fat", value: "\(Int(nfTotalFat))")
                                }
                        
                            Spacer()
                            // display for Carbs
                            if let nfTotalCarbohydrate = foodItem.nfTotalCarbohydrate {
                                    ValueView(label: "Carbs", value: "\(Int(nfTotalCarbohydrate))")
                                }
                            
                            Spacer()
                            // display for Protein
                            if let nfProtein = foodItem.nfProtein {
                                    ValueView(label: "Protein", value: "\(Int(nfProtein))")
                                }
                           
                            Spacer()
                        }
                    }
                    
                    Text("Serving Size:")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack {
                        // Check and display serving weight in grams
                        
                       // if let servingWeightGrams = foodItem.servingWeightGrams {
                         //   SizeView(label: "Serving Size", value: "\(Int(servingWeightGrams)) grams")
                       // }
                        Spacer()
                        Spacer()

                        // Check and display metric quantity and unit
                        if let nfMetricQty = foodItem.nfMetricQty, let nfMetricUom = foodItem.nfMetricUom {
                            SizeView(label: "Qty", value: "\(Int(nfMetricQty)) \(nfMetricUom)")
                        }
                        Spacer()
                        //
                        if let servingQty = foodItem.servingQty, let servingUnit = foodItem.servingUnit {
                            SizeView(label: "Per", value: "\(Int(servingQty)) \(servingUnit)")
                        }
                        Spacer()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    
                    Text("Nutrition Facts")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if let nfTotalFat = foodItem.nfTotalFat {
                        DetailView(label: "Total Fat", value: "\(nfTotalFat) g")
                    }
                    if let nfSaturatedFat = foodItem.nfSaturatedFat {
                        DetailView(label: "Saturated Fat", value: "\(nfSaturatedFat) g")
                    }
                    if let nfCholesterol = foodItem.nfCholesterol {
                        DetailView(label: "Cholesterol", value: "\(nfCholesterol) mg")
                    }
                    if let nfSodium = foodItem.nfSodium {
                        DetailView(label: "Sodium", value: "\(nfSodium) mg")
                    }
                    if let nfTotalCarbohydrate = foodItem.nfTotalCarbohydrate {
                        DetailView(label: "Total Carbohydrate", value: "\(nfTotalCarbohydrate) g")
                    }
                    if let nfDietaryFiber = foodItem.nfDietaryFiber {
                        DetailView(label: "Dietary Fiber", value: "\(nfDietaryFiber) g")
                    }
                    if let nfSugars = foodItem.nfSugars {
                        DetailView(label: "Sugars", value: "\(nfSugars) g")
                    }
                    if let nfProtein = foodItem.nfProtein {
                        DetailView(label: "Protein", value: "\(nfProtein) g")
                    }
                    if let nfPotassium = foodItem.nfPotassium {
                        DetailView(label: "Potassium", value: "\(nfPotassium) mg")
                    }
                    if let nfP = foodItem.nfP {
                        DetailView(label: "Phosphorus", value: "\(nfP) mg")
                    }
                }
                .padding(10)
                .padding(.vertical, 4)
            }
        
    }
    
    private func ValueView(label: String, value: String) -> some View {
        
        let color: Color = determineColor(for: label, with: value)
        
        return VStack(spacing: 10) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color(.systemGray2))
                .fontWeight(.semibold)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .frame(width: 55, height: 55)
        .padding()
        .background(RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground)))
        .overlay( // Apply a rounded border
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.systemGray4), lineWidth: 1)
                .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
        )
    }
    
    private func determineColor(for nutrient: String, with value: String) -> Color {
        let value = Double(value) ?? 0
        switch nutrient {
        case "Cal":
            
            return Color("LightPurple")
        case "Fat":
            return value < 5 ? Color("EmeraldL") : (value <= 11 ? Color("AppOrange") : Color("AppRed"))
        case "Carbs":
            return value < 7 ? Color("EmeraldL") : (value <= 15 ? Color("AppOrange") : Color("AppRed"))
        case "Protein":
            return Color("LightBlue")
        default:
            return .primary
        }
    }

    
    private func SizeView(label: String, value: String) -> some View {
        VStack(spacing: 10) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color(.systemGray2))
                .fontWeight(.semibold)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .frame(width: 108, height: 40)
        .padding()
        .background(RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground)))
        .overlay( // Apply a rounded border
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.systemGray4), lineWidth: 1)
                .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
        )
    }
    
    private func DetailView(label: String, value: String) -> some View {
        HStack {
            Text("\(label)")
                
            Spacer()
            Text(value)
                .foregroundColor(Color(.systemGray2))
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self)
}

