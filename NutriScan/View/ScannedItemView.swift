//
//  ScannedItemView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-05.
//

import SwiftUI

struct ScannedItemView: View {
    @ObservedObject var vm: ScannerViewModel
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Default(\.currentTheme) var currentTheme
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        VStack {
            toolbar
            bottomContainerView
        }
        .navigationTitle("Scanned Item")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var toolbar: some View {
        VStack {
            if let foodItem = vm.itemDetails.first {
                HStack {
                    Button(action: {
                        discardScan()
                    }) {
                        Text("Discard")
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        saveScan(FoodItem: foodItem)
                    }) {
                        Text("Save")
                            .fontWeight(.semibold)
                            .foregroundColor(colorFromString(currentTheme))
                    }
                }
                .padding()
            }
        }
    }
    
    private var bottomContainerView: some View {
        VStack{
            if let foodItem = vm.itemDetails.first {
                
                NavigationStack {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Form{
                            VStack (alignment: .leading, spacing: 10){
                                Text(foodItem.foodName)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Text(foodItem.brandName ?? "")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            
                            Section(header: Text("Serving information")) {
                                HStack {
                                    Text("Serving Size:")
                                        .font(.subheadline) // Smaller text for the label
                                        .fontWeight(.regular)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    Text("\(Int(foodItem.servingQty ?? 1))")
                                        .font(.headline)
                                }
                                
                                HStack {
                                    Text("Serving Quantity:")
                                        .font(.subheadline) // Smaller text for the label
                                        .fontWeight(.regular)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    if let nfMetricQty = foodItem.nfMetricQty, let nfMetricUom = foodItem.nfMetricUom {
                                        Text("\(Int(nfMetricQty)) \(nfMetricUom)")
                                            .font(.headline)
                                    }
                                    
                                }
                            }
                            
                            Section(header: Text("Nutritional Value")) {
                                VStack(alignment: .leading, spacing: 10) {
                                    // Header Row
                                    HStack {
                                        Text("Nutrient")
                                            .fontWeight(.bold)
                                            .frame(width: screenSize.width * 0.41, alignment: .leading) // Fixed width for nutrient column
                                        Text("Value")
                                            .fontWeight(.bold)
                                            .frame(width: screenSize.width * 0.22, alignment: .leading) // Fixed width for value column
                                        Text("%DV")
                                            .fontWeight(.bold)
                                            .frame(width: screenSize.width * 0.12, alignment: .trailing) // Fixed width for %DV column
                                    }
                                    .padding(.bottom, 5)
                                    
                                    Divider()
                                        .frame(height: 1)
                                    
                                    
                                    if let nfCalories = foodItem.nfCalories {
                                        nutritionalRow(label: "Calories", value: "\(Int(nfCalories)) kcal", dailyValue: calculateDailyValue(nutrient: .other, value: nfCalories))
                                        Divider()
                                            .frame(height: 1)
                                    }
                                    
                                    
                                    
                                    if let nfTotalFat = foodItem.nfTotalFat {
                                        nutritionalRow(label: "Total Fat", value: "\(Int(nfTotalFat)) g", dailyValue: calculateDailyValue(nutrient: .fat, value: nfTotalFat))
                                        Divider()
                                            .frame(height: 1)
                                    }
                                    
                                    
                                    if let nfSaturatedFat = foodItem.nfSaturatedFat {
                                        nutritionalRow(label: "Saturated Fat", value: String(format: "%.1f g", nfSaturatedFat), dailyValue: calculateDailyValue(nutrient: .saturatedFat, value: nfSaturatedFat))
                                        Divider()
                                            .frame(height: 1)
                                    }
                                    
                                    
                                    if let nfTotalCarbohydrate = foodItem.nfTotalCarbohydrate {
                                        nutritionalRow(label: "Carbohydrate", value: "\(Int(nfTotalCarbohydrate)) g", dailyValue: calculateDailyValue(nutrient: .other, value: nfTotalCarbohydrate))
                                        Divider()
                                            .frame(height: 1)
                                    }
                                    
                                    
                                    
                                    if let nfDietaryFiber = foodItem.nfDietaryFiber {
                                        nutritionalRow(label: "Dietary Fiber", value: "\(Int(nfDietaryFiber)) g", dailyValue: calculateDailyValue(nutrient: .fibre, value: nfDietaryFiber))
                                        Divider()
                                            .frame(height: 1)
                                    }
                                    
                                    
                                    
                                    if let nfSugars = foodItem.nfSugars {
                                        nutritionalRow(label: "Sugar", value: "\(Int(nfSugars)) g", dailyValue: calculateDailyValue(nutrient: .sugar, value: nfSugars))
                                        Divider()
                                            .frame(height: 1)
                                        
                                    }
                                    
                                    
                                    
                                    if let nfProtein = foodItem.nfProtein {
                                        nutritionalRow(label: "Protein", value: "\(Int(nfProtein)) g", dailyValue: calculateDailyValue(nutrient: .other, value: nfProtein))
                                        Divider()
                                            .frame(height: 1)
                                    }
                                    
                                    
                                    
                                    
                                    
                                    if let nfCholesterol = foodItem.nfCholesterol {
                                        nutritionalRow(label: "Cholesterol", value: "\(Int(nfCholesterol)) mg", dailyValue: calculateDailyValue(nutrient: .cholesterol, value: nfCholesterol))
                                        Divider()
                                            .frame(height: 1)
                                    }
                                    
                                    
                                    
                                    if let nfSodium = foodItem.nfSodium {
                                        nutritionalRow(label: "Sodium", value: "\(Int(nfSodium)) mg", dailyValue: calculateDailyValue(nutrient: .sodium, value: nfSodium))
                                        
                                        Divider()
                                            .frame(height: 1)
                                    }
                                    
                                    
                                    
                                    if let nfPotassium = foodItem.nfPotassium {
                                        nutritionalRow(label: "Potassium", value: "\(Int(nfPotassium))", dailyValue: calculateDailyValue(nutrient: .other, value: nfPotassium))
                                        Divider()
                                            .frame(height: 1)
                                    }
                                    
                                    
                                    
                                    if let nfP = foodItem.nfP {
                                        nutritionalRow(label: "Phosphorus", value: "\(Int(nfP)) mg", dailyValue: calculateDailyValue(nutrient: .other, value: nfP))
                                        
                                    }
                                }
                                .padding()
                                
                            }
                        }
                        
                    }
                }
            }
        }
    }
        
        @ViewBuilder
        func nutritionalRow(label: String, value: String?, dailyValue: Double?) -> some View {
            HStack {
                if label == "Calories" || label == "Total Fat" ||  label == "Carbohydrate" ||  label == "Protein"  {
                    Text(label)
                        .bold()
                        .font(.headline)
                        .frame(width: screenSize.width * 0.41, alignment: .leading)
                } else {
                    Text(label)
                        .font(.subheadline)
                        .frame(width: screenSize.width * 0.41, alignment: .leading)
                }
                
                if let value = value {
                    Text(value)
                        .frame(width: screenSize.width * 0.22, alignment: .leading)
                        .foregroundColor(.gray)
                }
                if let dailyValue = dailyValue {
                    Text("\(Int(dailyValue))%")
                        .frame(width: screenSize.width * 0.12, alignment: .trailing)
                        .foregroundColor(dailyValue >= 15 ? Color("SunsetL") : .gray)
                }
                
            }
        }
        
        func calculateDailyValue(nutrient: Nutrient, value: Double) -> Double? {
            // Placeholder function to calculate %DV based on nutrient type and value
            switch nutrient {
            case .fat:
                return (value / 75) * 100
            case .sugar:
                return (value / 100) * 100
            case .saturatedFat:
                return (value / 20) * 100
            case .fibre:
                return (value / 28) * 100
            case .cholesterol:
                return (value / 300) * 100
            case .sodium:
                return (value / 2300) * 100
            default:
                return nil
            }
        }
        
        enum Nutrient {
            case fat, sugar, protein, sodium, saturatedFat, fibre, cholesterol, other
        }
        
        
        private func saveScan(FoodItem foodItem: FoodItem) {
            // Implement saving logic here, possibly updating the SwiftData model
            withAnimation {
                let newItem = Item(foodItem: foodItem)
                modelContext.insert(newItem)
                vm.showScannedItemView = false
                vm.clearDataForNewScan()
                vm.isScannerActive = false
                dismiss()
            }
        }
        
        private func discardScan() {
            // Implement discard logic here if needed, like clearing temporary data
            vm.showScannedItemView = false
            vm.clearDataForNewScan()
            vm.refreshScannerView()
        }
    }

                
                
