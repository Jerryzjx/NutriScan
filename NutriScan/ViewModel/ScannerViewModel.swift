//
//  ScannerViewModel.swift
//  NutriScan
//
//  Created by leonard on 2024-02-03.
//

import Foundation
import SwiftUI
import VisionKit
import AVKit

enum ScanType {
    case text, barcode
}


enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvaliable
    case scannerAvaliable
    case scannerNotAvaliable
}



@MainActor
final class ScannerViewModel: ObservableObject {
    
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    @Published var recognizedData: [RecognizedItem] = []
    //@Published var scanType: ScanType = .barcode
    @Published var itemDetails: [FoodItem] = []
    @Published var showScannedItemView: Bool = false
    
    private var isScannerAvaliable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccessStatus = .cameraNotAvaliable
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case.authorized:
            dataScannerAccessStatus = isScannerAvaliable ? .scannerAvaliable : .scannerNotAvaliable
            
            
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessNotGranted
            
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            
            if granted {
                dataScannerAccessStatus = isScannerAvaliable ? .scannerAvaliable : .scannerNotAvaliable
            } else {
                dataScannerAccessStatus = .cameraAccessNotGranted
            }
        
        default: break
        }
        
    }
    
    func fetchDataForScannedBarcode(_ barcode: String) {
        Task {
            do {
                let fetchedItem = try await APIManager.shared.searchItem(with: barcode)
                DispatchQueue.main.async {
                    // Update your itemDetails based on the API response
                    // This is simplified; you'd likely want to update with actual item details
                    self.itemDetails.append(contentsOf: fetchedItem)
                    // Trigger view transition
                    self.showScannedItemView = true
                }
            } catch {
                print("Error fetching item details: \(error)")
            }
        }
    }

        // Assuming you have a function to process recognized items
        func processRecognizedItems() {
            for item in recognizedData {
                if case .barcode(let barcode) = item, let barcodeValue = barcode.payloadStringValue {
                    fetchDataForScannedBarcode(barcodeValue)
                }
            }
        }
    
}
