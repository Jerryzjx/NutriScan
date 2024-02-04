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
    
}
