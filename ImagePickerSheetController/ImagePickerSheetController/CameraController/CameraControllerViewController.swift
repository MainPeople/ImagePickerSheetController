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
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
 
    private func getCameraLayer() {
        guard view.layer.sublayers != nil else { return }
        for sublayer in view.layer.sublayers! {
            if sublayer.isKind(of: AVCaptureVideoPreviewLayer.self) {
                cameraLayer = sublayer as! AVCaptureVideoPreviewLayer
            }
        }
    }

    
    // MARK: - Settings 
    
    private func setupSettings() {
//        definesPresentationContext = true
    }
    
    // MARK: - UI
    
    private func setupUISettings() {
        view.backgroundColor = .black
        
    }
    
    

}
