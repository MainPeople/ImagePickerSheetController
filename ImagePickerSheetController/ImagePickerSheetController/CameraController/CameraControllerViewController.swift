//
//  CameraControllerViewController.swift
//  ImagePickerSheetController
//
//  Created by Alexsander Khitev on 2/13/17.
//  Copyright © 2017 Laurin Brandner. All rights reserved.
//

import UIKit
import AVFoundation

class CameraControllerViewController: UIViewController {
    
    private var cameraLayer = AVCaptureVideoPreviewLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        // settings 
        setupSettings()
        // UI
        setupUISettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCameraLayer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        getCameraLayer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func getCameraLayer() {
        guard view.layer.sublayers != nil else { return }
        for sublayer in view.layer.sublayers! {
            if sublayer.isKind(of: AVCaptureVideoPreviewLayer.self) {
                cameraLayer = sublayer as! AVCaptureVideoPreviewLayer
                
//                cameraLayer.frame = UIScreen.main.bounds
//                view.layer.addSublayer(cameraLayer)
            }
        }
    }
    
    
    private func addObserver() {
        if (!UIDevice.current.isGeneratingDeviceOrientationNotifications) {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange, object: nil, queue: OperationQueue.main) { [weak self] (_) -> Void in
            self?.cameraLayer.connection.videoOrientation = AVCaptureVideoOrientation.orientationFromUIDeviceOrientation(UIDevice.current.orientation)
        }
    }
    
    // MARK: - Settings 
    
    private func setupSettings() {
        definesPresentationContext = true
    }
    
    // MARK: - UI
    
    private func setupUISettings() {
        view.backgroundColor = .black
    }
    
    

}
