//
//  CameraSliderDelegate.swift
//  ImagePickerSheetController
//
//  Created by Alexsander Khitev on 2/22/17.
//

import Foundation

@objc protocol CameraSliderDelegate {
    
    @objc optional func didChangeValue(_ value: CGFloat)
    
}
