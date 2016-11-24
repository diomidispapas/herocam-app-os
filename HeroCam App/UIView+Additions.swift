//
//  UIView+Additions.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 18/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor : UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set (newValue) {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set (newValue) {
            self.layer.borderWidth = newValue
        }
    }
}

extension UIView {
    var screenshot: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        
        if let tableView = self as? UITableView {
            tableView.superview?.layer.render(in: UIGraphicsGetCurrentContext()!)
        } else {
            layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
    func screenshot(with backgroundColor: UIColor?) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        
        // If we have a background collor begin by fillling the canvas
        if let backgroundColor = backgroundColor {
            let context = UIGraphicsGetCurrentContext();
            context!.setFillColor(backgroundColor.cgColor);
            context!.fill(self.bounds);
        }
        
        if let tableView = self as? UITableView {
            tableView.superview?.layer.render(in: UIGraphicsGetCurrentContext()!)
        } else {
            layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
