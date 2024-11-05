//
//  ScannerVC.swift
//  Barcode-Scanner
//
//  Created by Emre KARDAS on 11/5/24.
//

import AVFoundation
import UIKit

enum CameraError: String {
    case invalidDeviceInput = "Invalid device input"
    case invalidScannedValue = "Invalid scanned value"
}

protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String)
    func didSurface(error: CameraError)
}

final class ScannerVC: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate!
    
    init(scannerDelegate: ScannerVCDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        checkCameraAuthorization()
    }
    
    func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // İzin verilmiş, oturumu başlat
            setupCaptureSession()
        case .notDetermined:
            // Henüz izin istenmemiş, iste
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.setupCaptureSession()
                    } else {
                        self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
                    }
                }
            }
        default:
            // İzin verilmemiş veya kısıtlanmış
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
        }
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession(){
        DispatchQueue.global(qos: .background).async {
            // Kamera ve giriş cihazlarının kurulumu
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                DispatchQueue.main.async {
                    self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
                }
                return
            }

            let videoInput: AVCaptureDeviceInput
            do {
                try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                DispatchQueue.main.async {
                    self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
                }
                return
            }

            if self.captureSession.canAddInput(videoInput){
                self.captureSession.addInput(videoInput)
            } else{
                DispatchQueue.main.async {
                    self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
                }
                return
            }

            let metaDataOutput = AVCaptureMetadataOutput()

            if self.captureSession.canAddOutput(metaDataOutput){
                self.captureSession.addOutput(metaDataOutput)
                metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metaDataOutput.metadataObjectTypes = [.ean8, .ean13, .qr]
            } else {
                DispatchQueue.main.async {
                    self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
                }
                return
            }

            DispatchQueue.main.async {
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.previewLayer?.videoGravity = .resizeAspectFill
                self.previewLayer?.frame = self.view.layer.bounds
                self.view.layer.addSublayer(self.previewLayer!)
            }

            self.captureSession.startRunning()
        }
    }
    
    private func restartScanning() {
            if !captureSession.isRunning {
                DispatchQueue.global(qos: .background).async {
                    self.captureSession.startRunning()
                }
            }
        }
    func stopScanning() {
            if captureSession.isRunning {
                DispatchQueue.global(qos: .background).async {
                    self.captureSession.stopRunning()
                }
            }
        }
    }


extension ScannerVC : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        guard let barcode = readableObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }

        // Terminale mesaj yazdırma
        print("Tarandı: \(barcode)")

        // Kamerayı durdurmak istemiyorsanız aşağıdaki satırı kaldırın
        // captureSession.stopRunning()

        scannerDelegate?.didFind(barcode: barcode)
    }

}
