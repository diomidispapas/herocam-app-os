//
//  TACameraOverlayView.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 1/10/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

protocol TACameraOverlayViewDelegate: class {
    /// Delegate method that is invoked when the user presses the capture picture button
    func takePhotoButtonTouchedUpInside()
}

class TACameraOverlayView: UIView, NibLoadableView {
    weak var delegate:TACameraOverlayViewDelegate?
    var hidesBottomBar: Bool = false {
        didSet {
            bottomView.isHidden = hidesBottomBar
        }
    }
    
    @IBOutlet fileprivate weak var bottomView: UIView!
    @IBAction func takePhotoButtonTouchedUpInside(_ sender: AnyObject) {
        self.delegate?.takePhotoButtonTouchedUpInside()
    }
}
