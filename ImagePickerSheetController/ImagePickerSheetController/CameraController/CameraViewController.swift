//
//  CameraViewController.swift
//  ImagePickerSheetController
//
//  Created by Alexsander Khitev on 2/13/17.
//  Copyright © 2017 Laurin Brandner. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
//    private let cameraEngine = CameraEngine()
    
    var cameraEngine: CameraEngine!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Settings() 
        setupSettings()
        // UI
        addCameraLayer()
//         Camera Settings
        setupCameraEngineSettings()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUIElementsPositions()
    }

    // MARK: - Settings
    
    private func setupSettings() {
        definesPresentationContext = true
    }
    
    // MARK: - UI
    
    private func addCameraLayer() {
        view.backgroundColor = .white
        guard cameraEngine?.previewLayer != nil else { return }
//        view.layer.addSublayer(cameraEngine.previewLayer)
        view.layer.insertSublayer(cameraEngine.previewLayer, at: 0)
    }

    private func setupUIElementsPositions() {
        // Layer 
        guard cameraEngine?.previewLayer != nil else { return }
        cameraEngine.previewLayer.frame = view.frame
        debugPrint("cameraEngine.previewLayer.frame", cameraEngine.previewLayer.frame)
    }
    
    // MARK: - Camera Engine functions
    
    private func setupCameraEngineSettings() {
        guard cameraEngine?.previewLayer != nil else { return }
        cameraEngine.rotationCamera = true
    }
    
}
