//
//  LogFoodView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-10.
//

import SwiftUI
import SwiftData

struct WaveShapeLog: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start at the top left corner
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        // Draw a line to the bottom left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        // Draw a line to the bottom right corner, slightly above the bottom edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 50))
        // Draw a line back to the top right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        // Move back to the bottom left corner to start the curve
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // Add a curve to the bottom right corner, slightly above the bottom edge
        // Adjust control points to bring the curve's center more towards the center
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - 50),
                      control1: CGPoint(x: rect.minX + rect.width * 0.35, y: rect.maxY + rect.height * 0.22), // Control point 1 moved towards center
                      control2: CGPoint(x: rect.maxX - rect.width * 0.35, y: rect.maxY + rect.height * 0.22)) // Control point 2 mirrored
        
        return path
    }
    
}

struct LogFoodView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]
    @Default(\.currentTheme) var currentTheme
    @Default(\.isHealthKitEnabled) var isHealthKitEnabled
    
    @EnvironmentObject var vm: ScannerViewModel
    let screenSize: CGRect = UIScreen.main.bounds
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack(alignment: .leading, spacing:7){
                    ZStack {
                        WaveShapeLog()
                            .fill(colorFromString(currentTheme))
                            .opacity(0.4)
                            .frame(height: 170)
                            .shadow(color: .black, radius: 2, x: 0.0, y: 0.0)
                        
                        WaveShapeLog()
                            .fill(colorFromString(currentTheme))
                            .opacity(0.75)
                            .frame(height: 170)
                            .offset(x: 0, y: -20.0)
                            .shadow(color: .black, radius: 4, x: 0.0, y: 0.0)
                    }
                    // .ignoresSafeArea()
                    Spacer()
                    Spacer()
                    headerView
                    
                    HStack(spacing: 7) {
                        Image(systemName: "list.bullet.rectangle.fill")
                            .font(Font.title.weight(.bold))
                        
                        Text("Log History")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                    }
                    .padding(.leading, 15)
                    
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                ItemDetailView(foodItem: item)
                                
                                
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(item.foodName) // Display the food name
                                        .font(.headline)
                                    Text(item.brandName ?? "") // Display the brand name
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(7)
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.regularMaterial)
                                    .padding(5)
                            )
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .background(Color(uiColor: .systemBackground))
                    .padding(10)
                }
                Spacer()
            }
            .padding(.bottom, 70)
            .navigationTitle("Log Item")
            .ignoresSafeArea()
            
        }
        
    }
    
    private var headerView: some View{
        HStack {
            Spacer()
            NavigationLink(destination: BarCodeScannerView().environmentObject(vm)) {
                HStack(spacing: 9) {
                    Image(systemName: "barcode.viewfinder")
                        .font(Font.title.weight(.bold))
                    
                    VStack{
                        Text("Scan")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Barcode")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.white)
                .background(Color("EmeraldL").opacity(0.3))
                .cornerRadius(20)
            }
            .task {
                
                vm.isScannerActive = true
                await vm.requestDataScannerAccessStatus()
            }
            .padding()
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(width: screenSize.width * 0.475, height: screenSize.width * 0.175)
            
            NavigationLink(destination: ManualLogView()) {
                
                HStack(spacing: 9) {
                    Image(systemName: "pencil.and.list.clipboard")
                        .font(Font.title.weight(.bold))
                    VStack{
                        Text("Manual")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Entry")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
               
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.white)
                .background(Color("SeashoreL").opacity(0.3))
                .cornerRadius(20)
            }
           
            
            .padding()
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(width: screenSize.width * 0.475, height: screenSize.width * 0.175)
            
            
        }
        .frame(width: screenSize.width * 0.95, height: screenSize.width * 0.190)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

struct ItemDetailView: View {
    
    let foodItem: Item
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Default(\.currentTheme) var currentTheme
    @Default(\.isHealthKitEnabled) var isHealthKitEnabled
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        ZStack{
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
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                Text("\(Int(foodItem.servingQty ?? 1))")
                                    .font(.headline)
                            }
                            
                            HStack {
                                Text("Serving Quantity:")
                                    .font(.subheadline)
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
                        .toolbar {
                            // Define the toolbar items here
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    addFoodItem(foodItem: foodItem)
                                    // success haptics
                                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                                }) {
                                    Image(systemName: "plus.circle")
                                    Text("Add Again")
                                        .foregroundStyle(colorFromString(currentTheme))
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                   
                }
                .padding(10)
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
        
        func addFoodItem(foodItem: Item) {
            if isHealthKitEnabled {
                let healthKitManager = HealthKitManager()
                
                
                healthKitManager.saveNutritionalDataFromItem(for: foodItem) { success, error in
                    
                    if success {
                        
                        print("Data saved to HealthKit")
                    } else if let error = error {
                        
                        print("Error saving data to HealthKit: \(error.localizedDescription)")
                    }
                }
            }
            withAnimation {
                let newItem = Item(from: foodItem)
                modelContext.insert(newItem)
                dismiss()
            }
        }
    }
    
