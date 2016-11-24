//
//  SharePopoverRenderer.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/19/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import ServiceKit
import CacheKit

protocol Sharable {
    var title: String { get }
    var subtitle: String? { get }
    var image: UIImage? { get }
    var wikipediaURL: URL? { get }
}

struct Sharing: Sharable {
    let title: String
    let subtitle: String?
    let image: UIImage?
    let wikipediaURL: URL?
}

protocol SharePopoverRenderer {
    func display(shareSheet shareContent: Sharable)
}

extension SharePopoverRenderer where Self: UIViewController {
    func display(shareSheet shareContent: Sharable) {
        if let image = shareContent.image {
            let activityItems: [Any] = [shareContent.title as NSString, shareContent.subtitle ?? "", image, shareContent.wikipediaURL as Any]
            let activityViewController = UIActivityViewController(activityItems:activityItems, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion:nil)
        }
    }
    
    fileprivate func getImage(from url: URL, completionHandler: @escaping (Failable<UIImage, NetworkError>) -> Void) {
        let request = ImageRequest(imagePath: url.absoluteString)
        
        // The image is alsways cached as we are already presenting it
        if let cached = Cache.get(with: url.absoluteString) {
            completionHandler(.success(cached))
            return
        }
        
        let service = ImageService()
        service.get(request) { box in
            switch box {
            case .success(let image):
                Cache.set(image, withIdentifier: url.absoluteString)
                completionHandler(.success(image))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

