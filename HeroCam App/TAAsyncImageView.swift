//
//  TAAsyncImageView.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 1/30/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import ServiceKit
import CacheKit

final class TAAsyncImageView: UIView, NibLoadableView {

    // MARK: Outlets
    
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.image = UIImage(named: "Onboarding_background")
        }
    }
    @IBOutlet fileprivate weak var downloadedImageView: UIImageView!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    // MARK: Properties
    
    var url: URL? {
        didSet {
            
            // The image is alsways cached as we are already presenting it
            if let url = url, let cached = Cache.get(with: url.absoluteString) {
                downloadedImageView.image = cached
                downloadedImageView.alpha = 1
                return
            }
            
            activityIndicator.startAnimating()
            downloadedImageView.isHidden = true
            downloadedImageView.alpha = 0
            backgroundImageView.isHidden = false
            
            if let url = self.url {
                let request = ImageRequest(imagePath: url.absoluteString)
                let service = ImageService()
                service.get(request) { [weak self] box in
                    guard let strongSelf = self else { return }
                    switch box {
                    case .success(let image):
                        Cache.set(image, withIdentifier: url.absoluteString)
                        strongSelf.activityIndicator.stopAnimating()
                        strongSelf.downloadedImageView.image = image
                        strongSelf.downloadedImageView.isHidden = false
                        UIView.animate(withDuration: 0.5, animations: {
                            strongSelf.downloadedImageView.alpha = 1
                        })
                        
                    case .failure(_):
                        strongSelf.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
