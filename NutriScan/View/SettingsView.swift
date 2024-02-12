//
//  SettingsView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-10.
//

import SwiftUI
import KeyboardKit

class KeyboardController: KeyboardInputViewController {}

struct WaveShapeSettings: Shape {
    
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

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}
extension View {
    func dismissKeyboard() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

struct SettingsView: View {
    @Default(\.caloriesGoalText) var caloriesGoalText
    @Default(\.carbohydrateGoalText) var carbohydrateGoalText
    @Default(\.proteinGoalText) var proteinGoalText
    @Default(\.fatGoalText) var fatGoalText
    @Default(\.currentTheme) var currentTheme
    @Default(\.isHealthKitEnabled) var isHealthKitEnabled
    
    @Environment(\.modelContext) var modelContext
    
    @State private var newCaloriesGoal = ""
    @State private var newCarbohydrateGoal = ""
    @State private var newProteinGoal = ""
    @State private var newFatGoal = ""
    @State private var isDeletingAlert = false
    @FocusState var isInputFieldFocused: FocusedField?
    
    enum FocusedField:Hashable{
        case calories, carbohydrates, protein, fat
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                ZStack {
                    
                    WaveShapeSettings()
                        .fill(colorFromString(currentTheme))
                        .opacity(0.4)
                        .frame(height: 170)
                        .shadow(color: .black, radius: 2, x: 0.0, y: 0.0)
                    
                    WaveShapeSettings()
                        .fill(colorFromString(currentTheme))
                        .opacity(0.75)
                        .frame(height: 170)
                        .offset(x: 0, y: -20.0)
                        .shadow(color: .black, radius: 4, x: 0.0, y: 0.0)
                }
                
                
                //   .ignoresSafeArea()
                Spacer()
                Spacer()
                
                Form {
                    
                    Section(header: Text("Themes")) {
                        NavigationLink(destination: ThemeSelectionView()) {
                            Text("Change Theme")
                        }
                    }
                    
                    Section(header: Text("Nutrient Goals")) {
                        VStack(alignment: .leading) {
                            Text("Calories Goal (kcal), Current Goal: \(caloriesGoalText) kcal")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Modify Your Calories Goal", text: $newCaloriesGoal)
                                .keyboardType(.numberPad)
                                .focused($isInputFieldFocused, equals: .calories)
                                .onSubmit {
                                    
                                    // submit and validate data
                                }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Protein Goal (g), Current Goal: \(proteinGoalText) g")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Modify Your Protein Goal", text: $newProteinGoal)
                                .keyboardType(.numberPad)
                                .focused($isInputFieldFocused, equals: .protein)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Carbohydrate Goal (g), Current Goal: \(carbohydrateGoalText) g")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Modify Your Carbohydrates Goal", text: $newCarbohydrateGoal)
                                .keyboardType(.numberPad)
                                .focused($isInputFieldFocused, equals: .carbohydrates)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Fat Goal (g), Current Goal: \(fatGoalText) g")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Modify Your Fat Goal", text: $newFatGoal)
                                .keyboardType(.numberPad)
                                .focused($isInputFieldFocused, equals: .fat)
                            
                        }
                        
                        Button("Update Goal") {
                            // Perform the save action here
                            switch isInputFieldFocused {
                            case .calories:
                                if !newCaloriesGoal.isEmpty {
                                    validateAndStoreInput(newCaloriesGoal, for: "Calories")
                                }
                                isInputFieldFocused = nil
                                newCaloriesGoal = ""
                            case .carbohydrates:
                                if !newCarbohydrateGoal.isEmpty {
                                    validateAndStoreInput(newCarbohydrateGoal, for: "Carbohydrates")
                                }
                                isInputFieldFocused = nil
                                newCarbohydrateGoal = ""
                            case .protein:
                                if !newProteinGoal.isEmpty {
                                    validateAndStoreInput(newProteinGoal, for: "Protein")
                                }
                                isInputFieldFocused = nil
                                newProteinGoal = ""
                            case .fat:
                                if !newFatGoal.isEmpty {
                                    validateAndStoreInput(newFatGoal, for: "Fat")
                                }
                                isInputFieldFocused = nil
                                newFatGoal = ""
                                // Reset focus or perform additional actions as necessary
                            default:
                                break
                            }
                        }
                    }
                        
                        
                        Section(header: Text("HealthKit")) {
                            Toggle(isOn: $isHealthKitEnabled) {
                                Text("Save Data to Health App")
                            }
                        }
                        
                        
                        
                        Section {
                            Button("Delete All User Data") {
                                isDeletingAlert = true
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                            }
                            .alert(isPresented: $isDeletingAlert) {
                                Alert(title: Text("Are you sure?"),
                                      message: Text("This will delete all user data."),
                                      primaryButton: .destructive(Text("Delete")) {
                                    do {
                                            try modelContext.delete(model: Item.self)
                                        } catch {
                                            fatalError(error.localizedDescription)
                                        }
                                },
                                      secondaryButton: .cancel())
                            }
                            .foregroundColor(.red)
                            
                        }
                        
                        Section(header: Text("About Us")) {
                            VStack(alignment: .leading) {
                                
                                Link("Visit Our Website", destination: URL(string: "https://github.com/Jerryzjx/NutriScan")!)
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                    }.padding(.bottom, 70)
                    
                    
                }
                .ignoresSafeArea()
                .navigationBarTitle("Settings")
                
            }
            
        }
        
        func validateAndStoreInput(_ input: String, for nutrient: String) {
            guard let value = Int(input), value >= 1, value <= 5000 else {
                // Handle invalid input, e.g., show an alert or reset to a default value
                return
            }
            
            switch nutrient {
            case "Calories":
                caloriesGoalText = String(value)
            case "Carbohydrates":
                // Perform similar validation for carbohydrates if necessary
                carbohydrateGoalText = String(value)
            case "Protein":
                // Perform similar validation for protein if necessary
                proteinGoalText = String(value)
            case "Fat":
                // Perform similar validation for fat if necessary
                fatGoalText = String(value)
            default:
                break // Unknown nutrient, handle appropriately
            }
        }
    }
    
    
    
