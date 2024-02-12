//
//  WelcomeView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-05.
//

import SwiftUI

struct WaveShape: Shape {
    
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
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - 50),
                      // Adjust these control points to create a larger, more natural curve
                      control1: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.maxY + rect.height * 0.5),
                      control2: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.maxY))
        
        return path
    }
    
}

struct BottomWaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start at the bottom right corner
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Draw a line to the top right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        // Draw a line to the top left corner, slightly below the top edge to mimic the original elevation
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 50))
        // Draw a line back to the bottom left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // Move to the top right corner to start the curve
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        // Add a curve to the top left corner, slightly below the top edge, mirroring the original curve but inverted vertically
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.minY + 50),
                      // Mirror the control points across the x-coordinate and adjust vertically for the mirrored curve
                      control1: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.minY - rect.height * 0.5),
                      control2: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.minY))
        
        return path
    }
    
}

struct WelcomeView: View {
    var topShapeHeight: CGFloat = 175
    var bottomShapeHeight: CGFloat = 100
    @EnvironmentObject var vm: ScannerViewModel
    @Default(\.currentTheme) var currentTheme
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    
                    WaveShape()
                        .fill(colorFromString(currentTheme))
                        .opacity(0.4)
                        .frame(height: topShapeHeight)
                        .shadow(color: .black, radius: 2, x: 0.0, y: 0.0)
                    
                    WaveShape()
                        .fill(colorFromString(currentTheme))
                        .frame(height: topShapeHeight)
                        .offset(x: 0, y: -20.0)
                        .shadow(color: .black, radius: 4, x: 0.0, y: 0.0)
                }
                
                Spacer()
                Spacer()
                Spacer()
                VStack {
                    Text("[NutriScan]")
                        .font(.system(size: 52))
                        .fontWeight(.heavy)
                        .foregroundStyle(
                            gradientFromString(currentTheme)
                        )
                }
                .padding(7)
                
                VStack (spacing: 6){
                    HStack (spacing: 4){
                        Image(systemName: "barcode.viewfinder")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Scan. Understand.")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    HStack (spacing: 4){
                        Image(systemName: "leaf")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(colorFromString(currentTheme))
                        Text("Eat Smart.")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                gradientFromString(currentTheme)
                            )
                    }
                }
                Spacer()
                Spacer()
                
                
                NavigationLink(destination: HomeView().environmentObject(vm)) { // This is where you navigate to HomeView
                    HStack(spacing: 7) {
                        Image(systemName: "arrowtriangle.right.fill")
                            .font(Font.title.weight(.bold))
                        
                        Text("Get Started")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [Color("EmeraldR"), Color("EmeraldL")], startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(25)
                }
                .padding(40)
               // .padding(.bottom, 35)
                
                ZStack {
                    BottomWaveShape()
                        .fill(LinearGradient(colors: [Color("EmeraldR"), Color("EmeraldL")], startPoint: .leading, endPoint: .trailing))
                        .opacity(0.4)
                        .frame(height: bottomShapeHeight)
                        .shadow(color: .black, radius: 2, x: 0.0, y: 0.0)
                    
                    BottomWaveShape()
                        .fill(LinearGradient(colors: [Color("EmeraldL"), Color("EmeraldR")], startPoint: .leading, endPoint: .trailing))
                        .opacity(0.95)
                        .frame(height: bottomShapeHeight)
                        .offset(x: 0, y: 20.0)
                        .shadow(color: .black, radius: 4, x: 0.0, y: 0.0)
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    WelcomeView()
}
