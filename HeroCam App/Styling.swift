//
//  Styling.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

protocol Styling {
    func applyStyling()
}

protocol HeroCamStyling: Styling { }

extension HeroCamStyling where Self: UIApplicationDelegate {
    func applyStyling() {
        let backImage = UIImage(named: "Back")
        let backButtonImage = backImage?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -400,vertical: 0), for: .default)
    }
}
