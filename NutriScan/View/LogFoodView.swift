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
    
    @EnvironmentObject var vm: ScannerViewModel
    let screenSize: CGRect = UIScreen.main.bounds
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack(alignment: .leading, spacing:7){
                    ZStack {
                        WaveShapeLog()
                            .fill(Color("EmeraldL"))
                            .opacity(0.4)
                            .frame(height: 170)
                            .shadow(color: .black, radius: 2, x: 0.0, y: 0.0)
                        
                        WaveShapeLog()
                            .fill(Color("EmeraldL"))
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
    
    var body: some View {
        ZStack{
            ScrollView {
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
                .padding(10)
                .toolbar {
                    // Define the toolbar items here
                    ToolbarItem(placement: .navigationBarTrailing) { // Adjust placement as needed
                        Button(action: {
                            addFoodItem(foodItem: foodItem)
                            // success haptics
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                        }) {
                            Image(systemName: "plus.circle")
                            Text("Add Again")
                                .foregroundStyle(Color("EmeraldL"))
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .padding(10)
        }
    }
        
        
        
        
        
        func ValueView(label: String, value: String) -> some View {
            
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
        
        func determineColor(for nutrient: String, with value: String) -> Color {
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
        
        
        func SizeView(label: String, value: String) -> some View {
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
        
        func DetailView(label: String, value: String, dailyValue: Double? = nil) -> some View {
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
        
        
        func addFoodItem(foodItem: Item) {
            withAnimation {
                let newItem = Item(from: foodItem)
                modelContext.insert(newItem)
                dismiss()
            }
        }
    }

