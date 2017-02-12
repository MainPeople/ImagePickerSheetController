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
    
    
    var cameraEngineLayer: CAReplicatorLayer!
    

    deinit {
//        cameraSession.stopRunning()
        NotificationCenter.default.removeObserver(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViewSettings()
        addCameraEngineLayer()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        for sublayer in containerView.layer.sublayers! {
            debugPrint("sublayer", sublayer)
        }
    }
    

    private func addCameraEngineLayer() {
        guard cameraEngineLayer != nil else {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { [weak self] (timer) in
                self?.addCameraEngineLayer()
                debugPrint("add camera layer = false")
            })
            return
        }
        cameraEngineLayer.frame = CGRect(x: 0, y: 0, width: 95, height: 95)
        cameraEngineLayer.position = CGPoint(x: 0, y: 0)
        cameraEngineLayer.contentsCenter = CGRect(x: 0, y: 0, width: 95, height: 95)
        
        containerView.layer.addSublayer(cameraEngineLayer)
        debugPrint("add camera layer")
    }

    
  
    
}


extension ImagePickerLiveCameraCollectionCell:  AVCaptureVideoDataOutputSampleBufferDelegate{
    
    fileprivate func setupViewSettings() {
        containerView.layer.cornerRadius = 7
        containerView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 7
        contentView.layer.masksToBounds = true
//        cameraLayer.cornerRadius = 7
//        cameraLayer.masksToBounds = true
    }
    
}
