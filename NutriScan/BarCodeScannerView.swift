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
        NavigationStack {
            VStack {
                if !vm.showScannedItemView { // Only show DataScannerView if ScannedItemView is not presented
                    switch vm.dataScannerAccessStatus {
                    case .scannerAvaliable:
                        DataScannerView(
                            recognizedData: $vm.recognizedData,
                            viewModel: _vm
                        )
                        .background(Color.gray.opacity(0.3))
                        .ignoresSafeArea()
                    case .cameraNotAvaliable:
                        Text("Your device does not have a camera")
                    case .scannerNotAvaliable:
                        Text("Scanner is not available")
                    case .cameraAccessNotGranted:
                        Text("Please grant camera access in settings")
                    case .notDetermined:
                        Text("Requesting camera access")
                    }
                } else {
                    // Display a placeholder or empty view when the camera is "frozen"
                    Color.gray.opacity(0.3)
                        .ignoresSafeArea()
                }
            }
            .sheet(isPresented: $vm.showScannedItemView) {
                ScannedItemView(vm: vm)
            }
        }
    }
}
