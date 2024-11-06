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
    weak var scannerDelegate: ScannerVCDelegate?
    
    // Son taranan barkodun kaydı ve engelleme süresi
    private var lastScannedCode: String?
    private var lastScanDate: Date?
    private let debounceInterval: TimeInterval = 2.0 // 2 saniye
    
    init(scannerDelegate: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraAuthorization()
    }
    
    func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCaptureSession()
                    } else {
                        self?.scannerDelegate?.didSurface(error: .invalidDeviceInput)
                    }
                }
            }
        default:
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    
    private func setupCaptureSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            if self.captureSession.inputs.isEmpty {
                self.addVideoInput()
            }
            
            if self.captureSession.outputs.isEmpty {
                self.addMetadataOutput()
            }
            
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
            
            self.captureSession.startRunning()
        }
    }
    
    private func addVideoInput() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            DispatchQueue.main.async {
                self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
            }
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
        } catch {
            DispatchQueue.main.async {
                self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
            }
        }
    }
    
    private func addMetadataOutput() {
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .qr]
        } else {
            DispatchQueue.main.async {
                self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
            }
        }
    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.layer.bounds
        if let previewLayer = previewLayer {
            view.layer.addSublayer(previewLayer)
        }
    }
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let barcode = metadataObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        // Barkodun tekrar taranmasını engellemek için debounce kontrolü
        if barcode == lastScannedCode, let lastScanDate = lastScanDate {
            if Date().timeIntervalSince(lastScanDate) < debounceInterval {
                // Tarama işlemini durdur ve tekrar tarama için bekle
                print("Beklemede: \(barcode)")
                return
            }
        }
        
        // Tarama başarılı; son taranan kodu ve zamanı güncelle
        lastScannedCode = barcode
        lastScanDate = Date()
        
        // Terminale taranan barkodu yazdırma
        print("Tarandı: \(barcode)")
        
        scannerDelegate?.didFind(barcode: barcode)
    }
}
