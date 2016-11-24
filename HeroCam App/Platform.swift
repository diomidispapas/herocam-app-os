//
//  Platform.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 24/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
