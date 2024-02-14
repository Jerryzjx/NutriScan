import SwiftUI

struct ManualLogView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Default(\.isHealthKitEnabled) var isHealthKitEnabled
    
    @State private var showingAlert = false
    @State private var foodName = ""
    @State private var brandName: String?
    @State private var baseServingQty: Int = 1
    @State private var servingQty: Int = 1
    @State private var metricQty: Double?
    @State private var calories: Double?
    @State private var totalFat: Double?
    @State private var sugar: Double?
    @State private var sodium: Double?
    @State private var protein: Double?
    @State private var foodCategories = ["Meal", "Bakery", "Beverages", "Snacks", "Dairy", "Fruits", "Fasting", ""]
    @State private var selectedCategory = "Meal"
    
    @FocusState private var isInputFieldFocused: Bool
    
    // Computed properties to adjust nutritional info based on serving quantity
    private var adjustedmetricQty: Double? {
        guard let metricQty = metricQty else { return nil }
        return metricQty * Double(servingQty) / Double(baseServingQty)
    }
    private var adjustedCalories: Double? {
        guard let calories = calories else { return nil }
        return calories * Double(servingQty) / Double(baseServingQty)
    }
    
    private var adjustedTotalFat: Double? {
        guard let totalFat = totalFat else { return nil }
        return totalFat * Double(servingQty) / Double(baseServingQty)
    }
    
    private var adjustedSugar: Double? {
        guard let sugar = sugar else { return nil }
        return sugar * Double(servingQty) / Double(baseServingQty)
    }
    
    private var adjustedSodium: Double? {
        guard let sodium = sodium else { return nil }
        return sodium * Double(servingQty) / Double(baseServingQty)
    }
    
    private var adjustedProtein: Double? {
        guard let protein = protein else { return nil }
        return protein * Double(servingQty) / Double(baseServingQty)
    }
    
    private var adjustedmetricQtyBinding: Binding<String> {
        Binding<String>(
            get: {
                if let adjustedmetricQty = self.adjustedmetricQty {
                    return String(format: "%.0f", adjustedmetricQty)
                } else {
                    return ""
                }
            },
            set: {
                if let value = Double($0) {
                    // Calculate and set the base calories value based on the adjusted input and current serving quantity
                    self.metricQty = value * Double(servingQty) / Double(baseServingQty)
                } else {
                    self.metricQty = nil
                }
            }
        )
    }
    
    private var adjustedCaloriesBinding: Binding<String> {
        Binding<String>(
            get: {
                if let adjustedCalories = self.adjustedCalories {
                    return String(format: "%.0f", adjustedCalories)
                } else {
                    return ""
                }
            },
            set: {
                if let value = Double($0) {
                    // Calculate and set the base calories value based on the adjusted input and current serving quantity
                    self.calories = value * Double(servingQty) / Double(baseServingQty)
                } else {
                    self.calories = nil
                }
            }
        )
    }
    
    private var adjustedTotalFatBinding: Binding<String> {
        Binding<String>(
            get: {
                if let adjustedTotalFat = self.adjustedTotalFat {
                    return String(format: "%.0f", adjustedTotalFat)
                } else {
                    return ""
                }
            },
            set: {
                if let value = Double($0) {
                    self.totalFat = value * Double(servingQty) / Double(baseServingQty)
                } else {
                    self.totalFat = nil
                }
            }
        )
    }
    
    private var adjustedSugarBinding: Binding<String> {
        Binding<String>(
            get: {
                if let adjustedSugar = self.adjustedSugar {
                    return String(format: "%.0f", adjustedSugar)
                } else {
                    return ""
                }
            },
            set: {
                if let value = Double($0) {
                    self.sugar = value * Double(servingQty) / Double(baseServingQty)
                } else {
                    self.sugar = nil
                }
            }
        )
    }
    
    private var adjustedSodiumBinding: Binding<String> {
        Binding<String>(
            get: {
                if let adjustedSodium = self.adjustedSodium {
                    return String(format: "%.0f", adjustedSodium)
                } else {
                    return ""
                }
            },
            set: {
                if let value = Double($0) {
                    self.sodium = value * Double(servingQty) / Double(baseServingQty)
                } else {
                    self.sodium = nil
                }
            }
        )
    }
    
    private var adjustedProteinBinding: Binding<String> {
        Binding<String>(
            get: {
                if let adjustedProtein = self.adjustedProtein {
                    return String(format: "%.0f", adjustedProtein)
                } else {
                    return ""
                }
            },
            set: {
                if let value = Double($0) {
                    self.protein = value * Double(baseServingQty) / Double(servingQty)
                } else {
                    self.protein = nil
                }
            }
        )
    }

    
    var body: some View {
        NavigationStack {
            ZStack{
                Form {
                    Section(header: Text("Food Details")) {
                        VStack(alignment: .leading) {
                            Text("Food Name").font(.caption).foregroundColor(.gray)
                            TextField("Food Name", text: $foodName)
                                .focused($isInputFieldFocused)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("Done") {
                                            isInputFieldFocused = false
                                        }
                                    }
                                }
                        }
                        
                        
                        VStack(alignment: .leading) {
                            
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(foodCategories, id: \.self) { category in
                                    Text(category).tag(category)
                                }
                            }
                            .focused($isInputFieldFocused)
                        }
                        
                        VStack(alignment: .leading) {
                            Stepper("Serving Quantity: \(servingQty)", value: $servingQty, in: 1...20)
                                .focused($isInputFieldFocused)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Metric quantity in grams").font(.caption).foregroundColor(.gray)
                            TextField("Metric Quantity (Optional)", text: adjustedmetricQtyBinding)
                                .keyboardType(.decimalPad)
                                .focused($isInputFieldFocused)
                        }
                        
                    }
                    
                    
                    
                    
                    Section(header: Text("Nutritional Information")) {
                        VStack(alignment: .leading) {
                            Text("Calories (required)").font(.caption).foregroundColor(.gray)
                            TextField("Calories", text: adjustedCaloriesBinding)
                                .keyboardType(.decimalPad)
                                .focused($isInputFieldFocused)
                        }
                       
                        
                        VStack(alignment: .leading) {
                            Text("Total Fat").font(.caption).foregroundColor(.gray)
                            TextField("Total Fat (g)", text: adjustedTotalFatBinding)
                                .keyboardType(.decimalPad)
                                .focused($isInputFieldFocused)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Sugar").font(.caption).foregroundColor(.gray)
                            TextField("Sugar (g) (Optional)", text: adjustedSugarBinding)
                                .keyboardType(.decimalPad)
                                .focused($isInputFieldFocused)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Sodium (mg)").font(.caption).foregroundColor(.gray)
                            TextField("Sodium (mg) (Optional)", text: adjustedSodiumBinding)
                                .keyboardType(.decimalPad)
                                .focused($isInputFieldFocused)
                        }
                        
                        
                        VStack(alignment: .leading) {
                            Text("Protein").font(.caption).foregroundColor(.gray)
                            TextField("Protein (g) (Optional)", text: adjustedProteinBinding)
                                .keyboardType(.decimalPad)
                                .focused($isInputFieldFocused)
                        }
                    }
                }
                
                .navigationTitle("Manual Entry")
                .toolbar {
                    // Place the Log Food button in the toolbar
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Log Food") {
                            isInputFieldFocused = false // Dismiss the keyboard
                            logFood()
                        }
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Missing Information"),
                        message: Text("Please fill in all required fields."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    
    private func logFood() {
        
       
        // check if all required fields are filled
        guard !foodName.isEmpty, let adjustedCalories = adjustedCalories else {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showingAlert = true // Show an alert if conditions are not met
            return
        }
        
        let newItem = Item(
            timestamp: Date(),
            foodName: foodName,
            brandName: brandName ?? selectedCategory,
            servingQty: servingQty,
            servingUnit: "servings",
            servingWeightGrams: metricQty ?? 0,
            nfMetricQty: adjustedmetricQty ?? 0,
            nfMetricUom: "g",
            nfCalories: adjustedCalories,
            nfTotalFat: adjustedTotalFat ?? 0,
            nfSaturatedFat: nil,
            nfCholesterol: nil,
            nfSodium: adjustedSodium ?? 0,
            nfTotalCarbohydrate: adjustedSugar ?? 0,
            nfDietaryFiber: nil,
            nfSugars: adjustedSugar ?? 0,
            nfProtein: adjustedProtein ?? 0,
            nfPotassium: nil,
            nfP: nil
        )
        
        if isHealthKitEnabled {
            let healthKitManager = HealthKitManager()
            
            
            healthKitManager.saveNutritionalDataFromItem(for: newItem) { success, error in
                
                if success {
                    
                    print("Data saved to HealthKit")
                } else if let error = error {
                    
                    print("Error saving data to HealthKit: \(error.localizedDescription)")
                }
            }
        }
        withAnimation {
            modelContext.insert(newItem)
            dismiss()
        }
    }
}
