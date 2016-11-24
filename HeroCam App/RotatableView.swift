//
//  RotatableView.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 28/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

private let kRotatableViewAnimationKey = "com.touristapp.circlesImageViewAnimationkey"

protocol RotatableView {
    func rotate(with duration: Double)
    func stopRotating()
}

extension RotatableView where Self: UIView {
    func rotate(with duration: Double = 1) {
        if self.layer.animation(forKey: kRotatableViewAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(M_PI * 2.0)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            self.layer.add(rotationAnimation, forKey: kRotatableViewAnimationKey)
        }
    }
    
    func stopRotating() {
        if self.layer.animation(forKey: kRotatableViewAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kRotatableViewAnimationKey)
        }
    }
}

extension UIImageView: RotatableView { }
