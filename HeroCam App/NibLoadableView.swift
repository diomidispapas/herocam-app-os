//
//  NibLoadableView.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 18/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

/**
 *  NibLoadableView protocol provides a default nib name throught its extension constrained to ```UIView``` subclasses. The default nib name is set to the name of the class.
 */
protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    static func fromNib<T : UIView>(_ nibNameOrNil: String? = nil) -> T {
        let v: T? = fromNib(nibNameOrNil)
        return v!
    }
    
    static func fromNib<T : UIView>(_ nibNameOrNil: String? = nil) -> T? {
        var view: T?
        let nibViews = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)
        for v in nibViews! {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
}
