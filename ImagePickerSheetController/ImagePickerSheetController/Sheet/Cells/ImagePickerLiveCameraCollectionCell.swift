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
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    
    fileprivate let cameraSession = AVCaptureSession()
    fileprivate var cameraLayer = AVCaptureVideoPreviewLayer()
    

    override func awakeFromNib() {
        super.awakeFromNib()
//         Initialization code
        setupAVCapture()
        setupViewSettings()
        orientationDidChange()
        setupUIHierarchy()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard self != nil else { return }
            if !self!.cameraSession.isRunning {
                self!.cameraSession.startRunning()
            }
        }

      
//        setupAVCapture()
//        setupViewSettings()
//        orientationDidChange()
//        setupUIHierarchy()
      
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] (timer) in
            guard self != nil else { return }
//            self!.setupAVCapture()
//            self!.setupViewSettings()
//            self!.orientationDidChange()
//            self!.setupUIHierarchy()
//            if self!.cameraSession.isRunning == false {
//                self!.cameraSession.startRunning()
//            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        orientationDidChange()
    }
    
    func orientationDidChange() {
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        switch orientation {
        case .portrait:
            cameraLayer.connection.videoOrientation = .portrait
        case .landscapeRight:
            cameraLayer.connection.videoOrientation = .landscapeLeft
        case .landscapeLeft:
            cameraLayer.connection.videoOrientation = .landscapeRight
        default:
            cameraLayer.connection.videoOrientation = .portrait
        }
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
