//
//  CameraSliderDelegate.swift
//  ImagePickerSheetController
//
//  Created by Alexsander Khitev on 2/22/17.
//  Copyright © 2017 Laurin Brandner. All rights reserved.
//

import Foundation

@objc protocol CameraSliderDelegate {
    
    @objc optional func didChangeValue(_ value: CGFloat)
    
}
