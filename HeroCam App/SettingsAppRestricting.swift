//
//  SettingsAppRestricting.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

protocol SettingsAppRestricting {
    func restrictSettingsApp()
}

extension SettingsAppRestricting where Self: UIViewController {
    func restrictSettingsApp() {
        let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        if let url = settingsUrl {
            UIApplication.shared.openURL(url)
        }
    }
}
