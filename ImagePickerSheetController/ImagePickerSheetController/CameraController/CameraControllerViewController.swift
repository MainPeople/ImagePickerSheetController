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
    private let shotButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let switchCameraButton = UIButton(type: .system)
    fileprivate let flashButton = UIButton(type: .custom)
    // Flash mode buttons 
    fileprivate let flashAutoButton = UIButton(type: .custom)
    fileprivate let flashOnButton = UIButton(type: .custom)
    fileprivate let flashOffButton = UIButton(type: .custom)
    
    // MARK: - Camera
    
    var cameraLayer = AVCaptureVideoPreviewLayer()
    var cameraEngine: CameraEngine!
    
    // MARK: - Flags
    
    fileprivate var areTorchElementsVisibles = false
    
    
    // MARK: - Images
    
    fileprivate struct FlashImage {
        let turnedOn = UIImage(named: "FlashTurnedOn", in: Bundle(identifier: "com.SCImagePickerSheetController"), compatibleWith: nil)
        let turnedOff = UIImage(named: "FlashTurnedOff", in: Bundle(identifier: "com.SCImagePickerSheetController"), compatibleWith: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // settings
        setupSettings()
        // UI
        setupUISettings()
        addUIElements()
        setupViewsSettings()
        // Buttons
        setupButtonsSettings()
        setupButtonsTargets()
        // Camera
        setupFlashMode(.auto)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCameraLayer()
        addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateCameraView()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        debugPrint("CameraController is deinit")
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
        // buttons
        shotButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(shotButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(cancelButton)
        switchCameraButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(switchCameraButton)
        // flash
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(flashButton)
        flashAutoButton.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(flashAutoButton)
        flashOnButton.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(flashOnButton)
        flashOffButton.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(flashOffButton)
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
        cameraPreviewView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        cameraPreviewView.topAnchor.constraint(equalTo: self.topBar.bottomAnchor).isActive = true
        
        // buttons
        shotButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor).isActive = true
        shotButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor).isActive = true
        shotButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        shotButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        cancelButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: bottomBar.leftAnchor, constant: 20).isActive = true
        
        switchCameraButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor).isActive = true
        switchCameraButton.rightAnchor.constraint(equalTo: bottomBar.rightAnchor, constant: -20).isActive = true
        switchCameraButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switchCameraButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        flashButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        flashButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        flashButton.leftAnchor.constraint(equalTo: topBar.leftAnchor, constant: 17).isActive = true
        flashButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor).isActive = true
        
        // mode 
        
        flashOnButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor).isActive = true
        flashOnButton.centerXAnchor.constraint(equalTo: topBar.centerXAnchor).isActive = true
        flashOnButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        flashOnButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        flashAutoButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor).isActive = true
        flashAutoButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        flashAutoButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        flashAutoButton.rightAnchor.constraint(equalTo: flashOnButton.leftAnchor, constant: -40).isActive = true
        
        
        flashOffButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor).isActive = true
        flashOffButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        flashOffButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        flashOffButton.leftAnchor.constraint(equalTo: flashOnButton.rightAnchor, constant: 40).isActive = true
    }
    
    // MARK: - Animation
    
    private func animateCameraView() {
        let widthValue = UIScreen.main.bounds.width
        let heightValue = UIScreen.main.bounds.height
        
        var setupWidthValue: CGFloat!
        var setupHeightValue: CGFloat!
        
        if widthValue < heightValue {
            setupWidthValue = widthValue
            setupHeightValue = heightValue - 44 - 96
        } else {
            setupWidthValue = heightValue
            setupHeightValue = widthValue - 44 - 96
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        self.cameraLayer.frame = CGRect(x: 0, y: 0, width: setupWidthValue, height: setupHeightValue)
        CATransaction.commit()
    }
    
    // MARK: - UI Elements settings
    
    private func setupViewsSettings() {
        bottomBar.backgroundColor = .black
        topBar.backgroundColor = .black
        
        //
        cameraPreviewView.backgroundColor = .black
        
        // bottom height
        let widthValue = UIScreen.main.bounds.width
        let heightValue = UIScreen.main.bounds.height
        
        let negativeValue: CGFloat = 44 + 96
    
        var Y: CGFloat = 0
        var X: CGFloat = 0
        
        if widthValue > heightValue {
            Y = widthValue - negativeValue
        } else {
            Y = heightValue - negativeValue
        }
        
        cameraLayer.frame = CGRect(x: X, y: Y, width: 0, height: 0)
        cameraPreviewView.layer.addSublayer(cameraLayer)
    }
    
    private func setupButtonsSettings() {
        let bundle = Bundle(identifier: "com.SCImagePickerSheetController")
        let shotImage = UIImage(named: "ShotCameraIcon", in: bundle, compatibleWith: nil)
        shotButton.setImage(shotImage, for: .normal)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let switchIcon = UIImage(named: "SwitchCameraIcon", in: bundle, compatibleWith: nil)
        switchCameraButton.setImage(switchIcon, for: .normal)
        switchCameraButton.tintColor = .white
        
        flashButton.setImage(FlashImage().turnedOn, for: .normal)
        flashButton.tintColor = .white 
        flashButton.addTarget(self, action: #selector(switchTorchModeElements), for: .touchUpInside)
        flashButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 27)
        
        flashOnButton.setTitle("On", for: .normal)
        flashOffButton.setTitle("Off", for: .normal)
        flashAutoButton.setTitle("Auto", for: .normal)
        
        flashOnButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        flashOffButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        flashAutoButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        flashOnButton.isHidden = true
        flashOffButton.isHidden = true
        flashAutoButton.isHidden = true
    }
    
    private func setupButtonsTargets() {
        cancelButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        switchCameraButton.addTarget(self, action: #selector(switchCameraDevice), for: .touchUpInside)
        // torch
        flashOnButton.addTarget(self, action: #selector(onTorchAction), for: .touchUpInside)
        flashOffButton.addTarget(self, action: #selector(offTorchAction), for: .touchUpInside)
        flashAutoButton.addTarget(self, action: #selector(autoTorchAction), for: .touchUpInside)
        shotButton.addTarget(self, action: #selector(shotAction), for: .touchUpInside)
    }
    
    
    // MARK: - Notification center
    
    private func addObservers() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(changeUIElementsPositions), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // MARK: - Rotation
    
    @objc private func changeUIElementsPositions() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            if UIDevice.current.orientation == .landscapeLeft {
                let rotation = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                self?.switchCameraButton.transform = rotation
                self?.flashButton.transform = rotation
                self?.flashButton.imageEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16)
            }
            if UIDevice.current.orientation == .landscapeRight {
                let transformRotation = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
                self?.switchCameraButton.transform = transformRotation
                self?.flashButton.transform = transformRotation
                self?.flashButton.imageEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16)
            }
            
            if UIDevice.current.orientation == .portrait {
                let transformRotation = CGAffineTransform(rotationAngle: 0)
                self?.switchCameraButton.transform = transformRotation
                self?.flashButton.transform = transformRotation
                self?.flashButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 27)
//                let x = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
            }
            
            if UIDevice.current.orientation == .portraitUpsideDown {
                let transformRotation = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                self?.switchCameraButton.transform = transformRotation
                self?.flashButton.transform = transformRotation
            }
            
        }) { (completion) in
            
        }
    }
    
}

// MARK: - Camera

extension CameraControllerViewController {
    
    // MARK: - Torch
    
    fileprivate func setupFlashMode(_ mode: AVCaptureFlashMode) {
        cameraEngine.flashMode = mode
    }
    
    @objc fileprivate func switchTorchModeElements() {
        flashOnButton.isHidden = areTorchElementsVisibles
        flashOffButton.isHidden = areTorchElementsVisibles
        flashAutoButton.isHidden = areTorchElementsVisibles
        
        // setup yellow color
        let flashMode: AVCaptureFlashMode = cameraEngine.flashMode
        
        switch flashMode {
        case .auto:
            flashAutoButton.setTitleColor(.yellow, for: .normal)
            flashOnButton.setTitleColor(.white, for: .normal)
            flashOffButton.setTitleColor(.white, for: .normal)
        case .on:
            flashOnButton.setTitleColor(.yellow, for: .normal)
            flashAutoButton.setTitleColor(.white, for: .normal)
            flashOffButton.setTitleColor(.white, for: .normal)
            
        case .off:
            flashOffButton.setTitleColor(.yellow, for: .normal)
            flashAutoButton.setTitleColor(.white, for: .normal)
            flashOnButton.setTitleColor(.white, for: .normal)
        }
        
        if areTorchElementsVisibles {
            areTorchElementsVisibles = false
        } else {
            areTorchElementsVisibles = true
        }
    }
    
    @objc fileprivate func autoTorchAction() {
        switchTorchModeElements()
        setupFlashMode(.auto)
        flashButton.tintColor = .white
        flashButton.setImage(FlashImage().turnedOn, for: .normal)
    }
    
    @objc fileprivate func onTorchAction() {
        switchTorchModeElements()
        setupFlashMode(.on)
        flashButton.tintColor = .yellow
        flashButton.setImage(FlashImage().turnedOn, for: .normal)
    }
    
    @objc fileprivate func offTorchAction() {
        switchTorchModeElements()
        setupFlashMode(.off)
        flashButton.tintColor = .white
        flashButton.setImage(FlashImage().turnedOff, for: .normal)
    }


    @objc fileprivate func switchCameraDevice() {
        cameraEngine.switchCurrentDevice()
    }
    
    @objc fileprivate func shotAction() {
        cameraEngine.capturePhoto { (image, error) -> (Void) in
            if error == nil {
                debugPrint("Here is an image")
            } else {
                debugPrint("error", error!.localizedDescription)
            }
        }
    }
    
}


// MARK: - Navigation

extension CameraControllerViewController {
    
    @objc fileprivate func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
}
