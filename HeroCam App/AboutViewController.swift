//
//  AboutViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/20/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController, NavigationTitlePresentable, BrowserPresentable, SFSafariViewControllerDelegate {

    @IBOutlet weak var versionLabel: UILabel! {
        didSet {
            if let versionNumber = Bundle.main.releaseVersionNumber,
                let buildNumber = Bundle.main.buildVersionNumber {
                self.versionLabel.text = "Version \(versionNumber)(\(buildNumber)) "
            }
            else {
                self.versionLabel.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationTitleView()
    }
    
    @IBAction func learnMoreButtonTouchedUpInside(_ sender: AnyObject) {
        self.presentBrowser(with: URL(string: Settings.Constants.SupportURLKey)!)
    }
    
}
