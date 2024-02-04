//
//  BarCodeScannerView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-03.
//

import SwiftUI
import VisionKit

struct BarCodeScannerView: View {
    
    @EnvironmentObject var vm: ScannerViewModel
    
    var body: some View {
        switch vm.dataScannerAccessStatus {
        case .scannerAvaliable:
            mainView
        case .cameraNotAvaliable:
            Text("Your device does not have a camera")
        case .scannerNotAvaliable:
            Text("Scanner is not avaliable")
        case .cameraAccessNotGranted:
            Text("Please grant camera access in settings")
        case .notDetermined:
            Text("Requesting camera access")
        }
    }
    
    private var mainView: some View {
        DataScannerView(
            recognizedData: $vm.recognizedData)
        .background { Color.gray.opacity(0.3) }
                .ignoresSafeArea()
              //  .id(vm.dataScannerViewId)
                .sheet(isPresented: .constant(true)) {
                    bottomContainerView
                        .background(.ultraThinMaterial)
                        .presentationDetents([.medium, .fraction(0.25)])
                        .presentationDragIndicator(.visible)
                        .interactiveDismissDisabled()
                        .onAppear {
                            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                  let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
                                return
                            }
                            controller.view.backgroundColor = .clear
                        }
                }
            }
    
    private var bottomContainerView: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(vm.recognizedData) { item in
                        switch item {
                        case .barcode(let barcode):
                            Text(barcode.payloadStringValue ?? "Unknown barcode")
                            
                        case .text(let text):
                            Text(text.transcript)
                            
                        @unknown default:
                            Text("Unknown")
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    BarCodeScannerView()
}
