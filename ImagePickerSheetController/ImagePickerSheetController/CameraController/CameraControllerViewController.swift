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

    // MARK: - UI
    
    private let bottomBar = UIView()
    private let topBar = UIView()
    private let cameraPreviewView = UIView()
    
    var cameraLayer = AVCaptureVideoPreviewLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // settings 
        setupSettings()
        // UI
        setupUISettings()
        addUIElements()
        setupViewsSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCameraLayer()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateCameraView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        getCameraLayer()
        setupUIElementsPositions()
    }

    override var prefersStatusBarHidden: Bool {
        return true
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
        definesPresentationContext = true
    }
    
    // MARK: - UI
    
    private func setupUISettings() {
        view.backgroundColor = .clear
    }
    
    private func addUIElements() {
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)
        cameraPreviewView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraPreviewView)
    }
    
    private func setupUIElementsPositions() {
        bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        topBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        cameraPreviewView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor).isActive = true
        cameraPreviewView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        cameraPreviewView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
//        animateCameraView()
    }
    
    private func setupViewsSettings() {
        bottomBar.backgroundColor = .black
        topBar.backgroundColor = .black
        
        //
        cameraPreviewView.backgroundColor = .red
        
        cameraLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        cameraPreviewView.layer.addSublayer(cameraLayer)
    }
    
    // MARK: - Animation
    
    private func animateCameraView() {
        UIView.animate(withDuration: 2, animations: {
            self.cameraPreviewView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            self.cameraPreviewView.topAnchor.constraint(equalTo: self.topBar.bottomAnchor).isActive = true
            
            // layer animate 
            
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(2)
            self.cameraLayer.frame = CGRect(x: 0, y: 44, width: 375, height: 375)
            CATransaction.commit()
            
            
            self.view.layoutIfNeeded()
        }) { (transtale) in
            
        }
    }
    
}
