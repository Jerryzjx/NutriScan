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
                            .foregroundColor(Color("EmeraldL"))
                    }
                }
                .padding()
            }
        }
    }
    
    private var bottomContainerView: some View {
        ScrollView {
            // Check if there is at least one item in itemDetails
            if let foodItem = vm.itemDetails.first {
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
                        let percentDailyValueFat = (nfTotalFat / 75.0) * 100 // Assuming adult daily value
                            DetailView(label: "Total Fat", value: "\(nfTotalFat) g", dailyValue: percentDailyValueFat)
                    }
                    if let nfSaturatedFat = foodItem.nfSaturatedFat {
                        let percentDailyValueSF = (nfSaturatedFat / 20.0) * 100
                        DetailView(label: "Saturated Fat", value: "\(nfSaturatedFat) g", dailyValue: percentDailyValueSF)
                    }
                    if let nfCholesterol = foodItem.nfCholesterol {
                        let percentDailyValueSF = (nfCholesterol / 300.00) * 100
                        DetailView(label: "Cholesterol", value: "\(nfCholesterol) mg", dailyValue: percentDailyValueSF)
                    }
                    if let nfSodium = foodItem.nfSodium {
                        let percentDailyValueSodium = (nfSodium / 2300.00) * 100
                        DetailView(label: "Sodium", value: "\(nfSodium) mg", dailyValue: percentDailyValueSodium)
                    }
                    if let nfTotalCarbohydrate = foodItem.nfTotalCarbohydrate {
                        DetailView(label: "Total Carbohydrate", value: "\(nfTotalCarbohydrate) g")
                    }
                    if let nfDietaryFiber = foodItem.nfDietaryFiber {
                        let percentDailyValueDietaryFiber = (nfDietaryFiber / 28.00) * 100
                        DetailView(label: "Dietary Fiber", value: "\(nfDietaryFiber) g", dailyValue: percentDailyValueDietaryFiber)
                    }
                    if let nfSugars = foodItem.nfSugars {
                        let percentDailyValueSugar = (nfSugars / 100.00) * 100
                        DetailView(label: "Sugars", value: "\(nfSugars) g", dailyValue: percentDailyValueSugar)
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
        .padding(10)
    }
    
    private func ValueView(label: String, value: String) -> some View {
        
        let color: Color = determineColor(for: label, with: value)
        
        return VStack(spacing: 10) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color(.systemGray))
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
                .stroke(Color(.systemGray), lineWidth: 1)
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
                .foregroundColor(Color(.systemGray))
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
                .stroke(Color(.systemGray), lineWidth: 1)
                .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
        )
    }
    
    private func DetailView(label: String, value: String, dailyValue: Double? = nil) -> some View {
        let width = UIScreen.main.bounds.width
        return HStack (){
            Text(label)
                .frame(width: width * 0.45, alignment: .leading)
                //.alignmentGuide(.leading) { d in d[.leading] }
            Text(value)
                .frame(width: width * 0.3, alignment: .leading)
                .foregroundColor(Color(.systemGray))
                //.alignmentGuide(.leading) { d in d[.leading] }
            // Display % Daily Value if applicable
            if let dailyValue = dailyValue {
                Text("\(Int(dailyValue))%")
                    .frame(width: width * 0.2, alignment: .trailing)
                    .foregroundColor(Color(.systemGray))
                    //.alignmentGuide(.leading) { d in d[.leading] }
            }
        }
    }

    
    
    private func saveScan(FoodItem foodItem: FoodItem) {
        // Implement saving logic here, possibly updating the SwiftData model
        withAnimation {
            let newItem = Item(foodItem: foodItem)
            modelContext.insert(newItem)
            vm.showScannedItemView = false
        }
    }
    
    private func discardScan() {
        // Implement discard logic here if needed, like clearing temporary data
        vm.showScannedItemView = false
        vm.refreshScannerView()
    }
}


