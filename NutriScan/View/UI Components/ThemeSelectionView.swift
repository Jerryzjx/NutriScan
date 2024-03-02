//
//  ThemeSelectionView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-11.
//

import SwiftUI

extension Color {
    static let themeEmeraldL = Color("EmeraldL")
    static let themeEmeraldR = Color("EmeraldR")
    static let themeSeashoreL = Color("SeashoreL")
    static let themeSeashoreR = Color("SeashoreR")
    static let themeSunsetL = Color("SunsetL")
    static let themeSunsetR = Color("SunsetR")
    static let themeFerrariL = Color("FerrariL")
    static let themeFerrariR = Color("FerrariR")
    static let themeSkybreezeL = Color("SkybreezeL")
    static let themeSkybreezeR = Color("SkybreezeR")
}

// Convert the string to the appropriate LinearGradient
func gradientFromString(_ gradientString: String) -> LinearGradient {
    switch gradientString {
    case "Emerald":
        return LinearGradient(gradient: Gradient(colors: [.themeEmeraldL, .themeEmeraldR]), startPoint: .leading, endPoint: .trailing)
    case "Seashore":
        return LinearGradient(gradient: Gradient(colors: [.themeSeashoreL, .themeSeashoreR]), startPoint: .leading, endPoint: .trailing)
    case "Sunset":
        return LinearGradient(gradient: Gradient(colors: [.themeSunsetL, .themeSunsetR]), startPoint: .leading, endPoint: .trailing)
    case "Ferrari":
        return LinearGradient(gradient: Gradient(colors: [.themeFerrariL, .themeFerrariR]), startPoint: .leading, endPoint: .trailing)
    case "Skybreeze":
        return LinearGradient(gradient: Gradient(colors: [.themeSkybreezeL, .themeSkybreezeR]), startPoint: .leading, endPoint: .trailing)
    default:
        return LinearGradient(gradient: Gradient(colors: [.themeEmeraldL, .themeEmeraldR]), startPoint: .leading, endPoint: .trailing)
    }
}


// Convert the string to the appropriate Color
func colorFromString(_ colorString: String) -> Color {
    switch colorString {
    case "Emerald":
        return .themeEmeraldL
    case "Seashore":
        return .themeSeashoreL
    case "Sunset":
        return .themeSunsetL
    case "Ferrari":
        return .themeFerrariL
    case "Skybreeze":
        return .themeSkybreezeL
    default:
        return .themeEmeraldL // Default color
    }
}

struct ThemeSelectionView: View {
    @Default(\.currentTheme) var currentTheme
    @State private var selectedTheme: String = "Emerald"
    let themeColors = ["Emerald", "Seashore", "Sunset", "Ferrari", "Skybreeze"]
    
    var body: some View {
        VStack {
            // Interface preview
            InterfacePreview(themeGradient: gradientFromString(selectedTheme), themeColor: colorFromString(selectedTheme))
                .frame(height: 200)
                .cornerRadius(12)
                .padding()

            // Theme selection grid
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(themeColors, id: \.self) { themeColor in
                        VStack(alignment: .center) {
                            // Text always present but opacity changes
                            Text(themeColor)
                                .fontWeight(.semibold)
                                .foregroundColor(colorFromString(themeColor))
                                .padding(.leading, -8)
                                .opacity(selectedTheme == themeColor ? 1 : 0.5)
                            ColorPickerView(selectedTheme: $selectedTheme, themeColor: themeColor)
                                //.padding()
                        }
                        .padding(.leading, themeColor == themeColors.first ? 15 : 10) // Add leading padding only for the first color picker
                    }
                }
                .padding()
            }
            .padding()
        }
        .onAppear {
            selectedTheme = currentTheme // Load the saved theme when the view appears
        }
    }
}

struct ColorPickerView: View {
    @Binding var selectedTheme: String
    let themeColor: String
    @Default(\.currentTheme) var currentTheme
    
    var body: some View {
        gradientFromString(themeColor)
            .frame(width: 75, height: 75)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(selectedTheme == themeColor ? Color.white : Color.clear, lineWidth: 3)
            )
            .onTapGesture {
                selectedTheme = themeColor
                currentTheme = themeColor // Update the current theme
            }
            .padding(.trailing, 10)
    }
}


    struct InterfacePreview: View {
        var themeGradient: LinearGradient
        var themeColor: Color
        @Default(\.currentTheme) var currentTheme
        
        var body: some View {
                VStack(spacing: 20) {
                    Text("[NutriScan]")
                        .font(.system(size: 52))
                        .fontWeight(.heavy)
                        .foregroundStyle(themeGradient)

                    VStack(spacing: 6) {
                        HStack(spacing: 4) {
                            Image(systemName: "barcode.viewfinder")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(themeGradient)
                            Text("Scan. Understand.")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(themeGradient)
                        }

                        HStack(spacing: 4) {
                            Image(systemName: "leaf")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(themeGradient)
                            Text("Eat Smart.")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(themeGradient)
                        }
                    }
                    .padding(.top, 20) // Add padding to the top of the VStack for spacing
                }
                .padding()
                .background(themeColor.opacity(0.135)) // Apply the selected theme gradient to the background
                .cornerRadius(15)
            }
        }
