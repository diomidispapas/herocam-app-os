//
//  TAWrongLandmarkView.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 1/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

protocol TAWrongLandmarkViewDelegate: class {
    func askYourFriendsForHelpButtonTouchedUpInside()
    func giveUsABetterAnswerButtonTouchedUpInside()
}

class TAWrongLandmarkView: UIView, NibLoadableView {
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
  
    // MARK: Properties
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    weak var delegate: TAWrongLandmarkViewDelegate?
    
    // MARK: Actions
    
    @IBAction func askYourFriendsButtonTouchedUpInside(_ sender: AnyObject) {
        self.delegate?.askYourFriendsForHelpButtonTouchedUpInside()
    }
    
    @IBAction func giveUsABetterAnswerButtonTouchedUpInside(_ sender: AnyObject) {
        self.delegate?.giveUsABetterAnswerButtonTouchedUpInside()
    }
}
