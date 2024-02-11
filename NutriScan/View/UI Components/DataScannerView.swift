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
        // Customizing the overlayContainerView
        let instructionLabel = UILabel()
        instructionLabel.text = "Find a barcode to scan"
        instructionLabel.textColor = .white
        instructionLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        instructionLabel.textAlignment = .center
        instructionLabel.layer.cornerRadius = 10
        instructionLabel.clipsToBounds = true
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.font = UIFont.boldSystemFont(ofSize: 18) // Set the font to bold
        
        viewController.overlayContainerView.addSubview(instructionLabel)
        
        // Constraints for the instructionLabel
        NSLayoutConstraint.activate([
            instructionLabel.centerXAnchor.constraint(equalTo: viewController.overlayContainerView.centerXAnchor),
            instructionLabel.bottomAnchor.constraint(equalTo: viewController.overlayContainerView.bottomAnchor, constant: -50), // Adjust this constant as needed
            instructionLabel.widthAnchor.constraint(equalToConstant: 250), // Adjust width as needed
            instructionLabel.heightAnchor.constraint(equalToConstant: 50) // Adjust height as needed
        ])
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        if viewModel.isScanningEnabled {
            try? uiViewController.startScanning()
            print("ENABLED")
        } else {
            print("Scanning is disabled")
            //uiViewController.stopScanning()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedData: $recognizedData, viewModel: viewModel)
    }
    
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        print("Scanning is dismantled")
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
            // clear the recognizedData array
            recognizedData.removeAll()
            print("didRemove: \(removedItems)")
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("becameUnavailableWithError: \(error.localizedDescription)")
        }
        
    }
    
}
