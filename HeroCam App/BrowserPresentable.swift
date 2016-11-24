//
//  BrowserPresentable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/23/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import SafariServices

protocol BrowserPresentable {
    func presentBrowser(with url: URL)
}

extension BrowserPresentable where Self: UIViewController, Self: SFSafariViewControllerDelegate {
    func presentBrowser(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        if #available(iOS 10.0, *) {
            safariVC.preferredControlTintColor = ColorPalette.blue.medium
        }
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
    
    // MARK: SFSafariViewControllerDelegate
    // TODO: Fix the @obj warning.
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

