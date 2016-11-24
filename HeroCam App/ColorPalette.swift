//
//  ColorPalette.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 18/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

/// Color pallet of the ```HeroCam``` app
enum ColorPalette {
    
    static let white = UIColor.white

    enum blue {
        static let light = UIColor(red:0.043, green:0.114 ,blue:0.157 , alpha:1.00)
        static let extraLight = UIColor(red:0.043, green:0.114 ,blue:0.157 , alpha:0.80)
        static let medium = UIColor(hex: 0x3CCAFF)
        static let fadedMedium = UIColor(hex: 0x3CCAFF, alpha: 0.50)
    }
    
    enum gray {
        static let extraLight = UIColor(red: 0.929, green: 0.929, blue: 0.937, alpha: 1)
        static let light = UIColor(white: 0.8374, alpha: 1.0)
        static let medium = UIColor(white: 0.4756, alpha: 1.0)
        static let dark = UIColor(white: 0.2605, alpha: 1.0)
    }
}
