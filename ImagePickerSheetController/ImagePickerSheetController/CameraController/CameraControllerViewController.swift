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
    

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
 
    private func getCameraLayer() {
        guard view.layer.sublayers != nil else { return }
        for sublayer in view.layer.sublayers! {
            if sublayer.isKind(of: AVCaptureVideoPreviewLayer.self) {
                cameraLayer = sublayer as! AVCaptureVideoPreviewLayer
            }
        }
    }
    
    
    private func addObserver() {
        if (!UIDevice.current.isGeneratingDeviceOrientationNotifications) {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange, object: nil, queue: OperationQueue.main) { [weak self] (_) -> Void in
            guard self != nil else { return }
            self!.cameraLayer.frame = self!.view.frame
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
