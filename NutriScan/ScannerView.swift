//
//  ScannerView.swift
//  NutriScan
//
//  Created by leonard on 2024-02-03.
//

import SwiftUI
import VisionKit
/*
@MainActor
struct ScannerView: UIViewControllerRepresentable {
    
    static let startScanLabel = "Start Scan"
    static let stopScanLabel = "Stop Scan"
    
    var scannerViewController: DataScannerViewController = DataScannerViewController(
        recognizedDataTypes:  [.barcode(symbologies: [.upce])],
        qualityLevel: .accurate,
        recognizesMultipleItems: false,
        isHighFrameRateTrackingEnabled: false,
        isHighlightingEnabled: false
    )
   
    func makeUIViewController(context: Context) -> DataScannerViewController {
        scannerViewController.delegate = context.coordinator
        
        // Add a button to start scanning
        let scanButton = UIButton(type: .system)
        scanButton.backgroundColor = UIColor.systemBlue
        scanButton.setTitle(ScannerView.startScanLabel, for: .normal)
        scanButton.setTitleColor(UIColor.white, for: .normal)
        
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        scanButton.configuration = config
        
        scanButton.addTarget(context.coordinator, action: #selector(Coordinator.startScanning(_:)), for: .touchUpInside)
        scanButton.layer.cornerRadius = 5.0
        scannerViewController.view.addSubview(scanButton)
        
        // Set up button constraints
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scanButton.centerXAnchor.constraint(equalTo: scannerViewController.view.centerXAnchor),
            scanButton.bottomAnchor.constraint(equalTo: scannerViewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        // Update any view controller settings here
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: ScannerView
        var roundBoxMappings: [UUID: UIView] = [:]
        
        init(_ parent: ScannerView) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            processAddedItems(items: addedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            processRemovedItems(items: removedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            processUpdatedItems(items: updatedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            processItem(item: item)
        }
        
        
        func processAddedItems(items: [RecognizedItem]) {
            for item in items {
                processItem(item: item)
            }
        }
        
        func processRemovedItems(items: [RecognizedItem]) {
            for item in items {
                removeRoundBoxFromItem(item: item)
            }
        }
        
        func processUpdatedItems(items: [RecognizedItem]) {
            for item in items {
                updateRoundBoxToItem(item: item)
            }
        }

        func processItem(item: RecognizedItem) {
            switch item {
            case .text(let text):
                print("Text Observation - \(text.observation)")
                print("Text transcript - \(text.transcript)")
                let frame = getRoundBoxFrame(item: item)
                // Adding the round box overlay to detected text
                addRoundBoxToItem(frame: frame, text: text.transcript, item: item)
            case .barcode:
                print("Barcode Observation")
                // print the barcode value
                print("Barcode value - \(item.value)")
            @unknown default:
                print("Should not happen")
            }
        }
        
        func addRoundBoxToItem(frame: CGRect, text: String, item: RecognizedItem) {
            //let roundedRectView = RoundRectView(frame: frame)
            //let roundedRectView = RoundedRectLabel(frame: frame)
            //roundedRectView.setText(text: text)
            //parent.scannerViewController.overlayContainerView.addSubview(roundedRectView)
            //roundBoxMappings[item.id] = roundedRectView
        }
        
        func removeRoundBoxFromItem(item: RecognizedItem) {
            if let roundBoxView = roundBoxMappings[item.id] {
                if roundBoxView.superview != nil {
                    roundBoxView.removeFromSuperview()
                    roundBoxMappings.removeValue(forKey: item.id)
                }
            }
        }
        
        func updateRoundBoxToItem(item: RecognizedItem) {
            if let roundBoxView = roundBoxMappings[item.id] {
                if roundBoxView.superview != nil {
                    let frame = getRoundBoxFrame(item: item)
                    roundBoxView.frame = frame
                }
            }
        }
        
        func getRoundBoxFrame(item: RecognizedItem) -> CGRect {
            let frame = CGRect(
                x: item.bounds.topLeft.x,
                y: item.bounds.topLeft.y,
                width: abs(item.bounds.topRight.x - item.bounds.topLeft.x) + 15,
                height: abs(item.bounds.topLeft.y - item.bounds.bottomLeft.y) + 15
            )
            return frame
        }
        
        // Add this method to start scanning
        @objc func startScanning(_ sender: UIButton) {
            if sender.title(for: .normal) == startScanLabel {
                try? parent.scannerViewController.startScanning()
                sender.setTitle(stopScanLabel, for: .normal)
            } else {
                parent.scannerViewController.stopScanning()
                sender.setTitle(startScanLabel, for: .normal)
            }
        }
    }
}
*/
