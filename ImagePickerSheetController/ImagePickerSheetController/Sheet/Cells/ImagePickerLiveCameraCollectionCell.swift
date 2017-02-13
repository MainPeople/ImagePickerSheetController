//
//  ImagePickerLiveCameraCollectionCell.swift
//  SwiftChats
//
//  Created by Alexsander Khitev on 2/7/17.
//  Copyright © 2017 Alexsander Khitev. All rights reserved.
//

import UIKit
import AVFoundation

class ImagePickerLiveCameraCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    
    fileprivate let cameraSession = AVCaptureSession()
    fileprivate var cameraLayer = AVCaptureVideoPreviewLayer()
    

    deinit {
        cameraSession.stopRunning()
        NotificationCenter.default.removeObserver(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupAVCapture()
        setupViewSettings()
        setupUIHierarchy()
        
        // Layer orientation
        orientationDidChange()
        setupStartOrientation()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupStartOrientation()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard self != nil else { return }
            if self!.cameraSession.isRunning == false {
                self!.cameraSession.startRunning()
            }
        }
    }
    
    private func orientationDidChange() {
        if (!UIDevice.current.isGeneratingDeviceOrientationNotifications) {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange, object: nil, queue: OperationQueue.main) { [weak self] (_) -> Void in
            guard self != nil else { return }
            self!.cameraLayer.connection.videoOrientation = AVCaptureVideoOrientation.orientationFromUIDeviceOrientation(UIDevice.current.orientation)
        }
    }
    
    private func setupStartOrientation() {
        cameraLayer.connection.videoOrientation = AVCaptureVideoOrientation.orientationFromUIDeviceOrientation(UIDevice.current.orientation)
    }
    
    private func setupUIHierarchy() {
        containerView.bringSubview(toFront: imageView)
    }
    
}


extension ImagePickerLiveCameraCollectionCell:  AVCaptureVideoDataOutputSampleBufferDelegate{
    
    func setupAVCapture(){
        cameraSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) as AVCaptureDevice
        
        beginSession(captureDevice)
        
        setupLayer()
    }
    
    private func beginSession(_ captureDevice: AVCaptureDevice) {
        var deviceInput: AVCaptureDeviceInput!
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        guard deviceInput != nil else { return }
        
        if cameraSession.canAddInput(deviceInput) {
            cameraSession.addInput(deviceInput)
        }
        
        let dataOutput = AVCaptureVideoDataOutput()
        
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
        
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        
        if cameraSession.canAddOutput(dataOutput) {
            cameraSession.addOutput(dataOutput)
        }
        
        cameraSession.commitConfiguration()
        
//        Timer.scheduledTimer(withTimeInterval: 0.001, repeats: false) { [weak self] (timer) in
//            self?.cameraSession.startRunning()
//        }
//        
//        cameraSession.startRunning()
        
//        let queue = DispatchQueue(label: "com.invasivecode.videoQueue") 
//        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    private func setupLayer() {
        cameraLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
        cameraLayer.frame = CGRect(x: 0, y: 0, width: 95, height: 95)
        cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        containerView.layer.addSublayer(cameraLayer)
    }
    
    fileprivate func setupViewSettings() {
        containerView.layer.cornerRadius = 7
        containerView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 7
        contentView.layer.masksToBounds = true
        cameraLayer.cornerRadius = 7
        cameraLayer.masksToBounds = true
    }
    
}
