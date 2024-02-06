//
//  DataScannerView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-03.
//

import Foundation
import SwiftUI
import VisionKit

struct DataScannerView: UIViewControllerRepresentable {
    
    @Binding var recognizedData: [RecognizedItem]
    @EnvironmentObject var viewModel: ScannerViewModel
    
    //let recognizedDataTypes: DataScannerViewController.RecognizedDataType
    // let recognizeMultipleItems: Bool
    
    // Source: https://developer.apple.com/documentation/visionkit/scanning_data_with_the_camera
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let viewController = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedData: $recognizedData, viewModel: viewModel)
    }
    
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        
        @Binding var recognizedData: [RecognizedItem]
        var viewModel: ScannerViewModel
        
        init(recognizedData: Binding<[RecognizedItem]>, viewModel: ScannerViewModel) {
            self._recognizedData = recognizedData
            self.viewModel = viewModel
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            print("didTapOn: \(item)")
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            print("didAdd: \(addedItems)")
            
            for item in addedItems {
                    if case let .barcode(barcode) = item, let barcodeValue = barcode.payloadStringValue {
                        // Use the existing function in the ViewModel to process the barcode
                        // Assuming you have a way to access the ViewModel instance here. If not, you'll need to pass it to the Coordinator.
                        self.viewModel.fetchDataForScannedBarcode(barcodeValue)

                        // Now that fetching is delegated to the ViewModel, you might reconsider if you need to immediately remove the barcode from recognizedData here
                        // If removal is necessary, ensure it's handled appropriately in context with your app's flow
                    }
                }
        }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        
        print("didRemove: \(removedItems)")
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        print("becameUnavailableWithError: \(error.localizedDescription)")
    }
    
}

}
