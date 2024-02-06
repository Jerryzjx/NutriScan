//
//  ScannedItemView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-05.
//

import SwiftUI

struct ScannedItemView: View {
    @ObservedObject var vm: ScannerViewModel
    //@Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            VStack {
                toolbar
                    .font(.custom("Geist-Regular", size: 16)) // Set the custom font for the toolbar text
                bottomContainerView
            }
            .background(Color("AppBG")) // Assuming "AppBG" is the name of your custom color
            .navigationTitle("Scanned Item")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        private var toolbar: some View {
            HStack {
                Button(action: {
                    discardScan()
                }) {
                    Text("Discard")
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button(action: {
                    saveScan()
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    
    private var bottomContainerView: some View {
        ScrollView {
                // Check if there is at least one item in itemDetails
                if let foodItem = vm.itemDetails.first {
                    VStack(alignment: .leading, spacing: 8) {
                        // Directly use foodItem since we're guaranteed to only have one
                        Text(foodItem.foodName)
                            .font(.headline)
                            .font(.custom("Geist-Regular", size: 18)) // Set the font for the food name
                        
                        
                        if let brandName = foodItem.brandName {
                            DetailView(label: "Brand", value: brandName)
                        }
                        if let servingQty = foodItem.servingQty, let servingUnit = foodItem.servingUnit {
                            DetailView(label: "Serving Quantity", value: "\(servingQty) \(servingUnit)")
                        }
                        if let servingWeightGrams = foodItem.servingWeightGrams {
                            DetailView(label: "Serving Weight", value: "\(servingWeightGrams) grams")
                        }
                        if let nfMetricQty = foodItem.nfMetricQty, let nfMetricUom = foodItem.nfMetricUom {
                            DetailView(label: "Metric Quantity", value: "\(nfMetricQty) \(nfMetricUom)")
                        }
                        if let nfCalories = foodItem.nfCalories {
                            DetailView(label: "Calories", value: "\(nfCalories) kcal")
                        }
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
                    .padding(.vertical, 4)
                }
            }
            .padding()
        }

    private func DetailView(label: String, value: String) -> some View {
            HStack {
                Text("\(label):")
                    .bold()
                    .font(.custom("GeistVariable-SemiBold", size: 15)) // Apply custom font here as well
                Text(value)
                    .font(.custom("Geist-Regular", size: 15)) // And here
            }
        }

    
    private func saveScan() {
        // Implement saving logic here, possibly updating the SwiftData model
       // presentationMode.wrappedValue.dismiss()
    }
    
    private func discardScan() {
        // Implement discard logic here if needed, like clearing temporary data
       // presentationMode.wrappedValue.dismiss()
    }
}


