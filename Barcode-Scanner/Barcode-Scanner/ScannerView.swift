//
//  ScannerView.swift
//  Barcode-Scanner
//
//  Created by Emre KARDAS on 11/5/24.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {

    @Binding var scannedBarcode: String
    
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView : self)
    }
    
    final class Coordinator: NSObject, ScannerVCDelegate {
        
        private let scannerView : ScannerView
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func didFind(barcode: String) {
            scannerView.scannedBarcode = barcode
        }
        
        func didSurface(error: CameraError) {
            print(error.rawValue)
        }
    }
}
