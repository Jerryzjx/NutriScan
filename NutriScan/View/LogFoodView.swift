//
//  LogFoodView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-10.
//

import SwiftUI

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
    
    @EnvironmentObject var vm: ScannerViewModel
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack(alignment: .center){
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
                    
                        HStack {
                            /*
                             BarCodeScannerView()
                             .environmentObject(vm)
                             
                             .task {
                             await vm.requestDataScannerAccessStatus()
                             }// Your barcode scanner view
                             .tabItem {
                             Label("Log", systemImage: "plus.app.fill")
                             }
                             */
                            NavigationLink(destination: BarCodeScannerView().environmentObject(vm)) {
                                Label("Scan", systemImage: "barcode.viewfinder")
                                    .foregroundStyle(.primary)
                                    .font(.title2)
                                    .padding()
                            }
                            .task {
                                await vm.requestDataScannerAccessStatus()
                            }
                            .padding()
                            .background(Color("EmeraldL").opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: screenSize.width * 0.425)
                            
                            NavigationLink(destination: ManualLogView()) {
                                Label("Log", systemImage: "plus.app.fill")
                                    .foregroundStyle(.primary)
                                    .font(.title2)
                                    .padding()
                            }
                            .task {
                                await vm.requestDataScannerAccessStatus()
                            }
                            .frame(width: screenSize.width * 0.425)
                            .padding()
                            .background(Color("SeashoreL").opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                        }
                        .frame(width: screenSize.width * 0.85)
                        
                        NavigationLink(destination: ContentView()) {
                            Text("View Log History")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(colors: [Color("SunsetR"), Color("SunsetL")], startPoint: .leading, endPoint: .trailing)
                                )
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .frame(width: screenSize.width * 0.85)
                        .padding()
                    }
                Spacer()
            }
            .navigationTitle("Log Item")
            .ignoresSafeArea()
        }
        
    }
}

#Preview {
    LogFoodView()
}
