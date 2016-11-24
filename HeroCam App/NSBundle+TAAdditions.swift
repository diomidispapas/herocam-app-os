//
//  NSBundle+TAAdditions.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 1/30/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

extension Bundle {
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
}
