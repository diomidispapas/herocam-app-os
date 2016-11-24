//
//  TALandmarkDescriptionView.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 1/16/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

protocol TALandmarkDescriptionViewDelegate: class {
    func viewOnWikipediaButtonTouchedUpInside()
    func shareButtonTouchedUpInside()
}

@IBDesignable final class TALandmarkDescriptionView: UIView, NibLoadableView {

    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var landmarkAsyncImageViewContainer: UIView! {
        didSet {
            self.landmarkAsyncImageView = TAAsyncImageView.fromNib()
            self.landmarkAsyncImageView!.frame = landmarkAsyncImageViewContainer!.frame
            self.landmarkAsyncImageViewContainer.addSubview(self.landmarkAsyncImageView!)
            self.translatesAutoresizingMaskIntoConstraints = false
            landmarkAsyncImageViewContainer?.centerXAnchor.constraint(equalTo: landmarkAsyncImageView!.centerXAnchor, constant: 0).isActive=true
            landmarkAsyncImageViewContainer?.centerYAnchor.constraint(equalTo: landmarkAsyncImageView!.centerYAnchor, constant: 0).isActive=true
        }
    }
    
    // MARK: Properties
    
    var landmarkAsyncImageView: TAAsyncImageView?
    var delegate:TALandmarkDescriptionViewDelegate?
    var imageURL: URL? {
        didSet {
            if let unwrappedLandmarkAsyncImageView = self.landmarkAsyncImageView {
                unwrappedLandmarkAsyncImageView.url = imageURL
            }
        }
    }
    
    // MARK: Actions
    @IBAction func viewOnWikipediaButtonTouchedUpInside(_ sender: AnyObject) {
        self.delegate?.viewOnWikipediaButtonTouchedUpInside()
    }
    
    @IBAction func shareButtonTouchedUpInside(_ sender: AnyObject) {
        self.delegate?.shareButtonTouchedUpInside()
    }
}
