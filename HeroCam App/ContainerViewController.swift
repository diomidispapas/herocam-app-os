//
//  ContainerViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/23/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import QuartzCore
import MessageUI

class ContainerViewController: UIViewController, NavigationTitlePresentable, FeedbackProvidable, CenterViewConrtollerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var containerView: UIView!
    
    // MARK: Properties

    internal var activeViewController: UIViewController? {
        willSet {
            removeInactiveViewController()
            updateActiveViewController(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationTitleView()
        self.setContainerViewController(.Home)
    }
    
    // MARK: SidePanelViewControllerDelegate
    
    func itemSelected(_ item: SidePanelOption) {
        self.setContainerViewController(item)
    }

    // MARK: Private

    /**
     Helper method for setting the current child view controller given the ```SidePanelOption``` option
     - parameter option: the ```SidePanelOption``` value
     */
    fileprivate func setContainerViewController(_ option: SidePanelOption) {
        switch option {
        case .Home:
            activeViewController = InitialViewController.instantiateFromStoryboard(self.storyboard!)
            break
            
        case .Saved:
            activeViewController = UIStoryboard(name: StoredStoryboard.storyboardIdentifier, bundle: nil).instantiateInitialViewController()
            break
            
        case .Help:
            activeViewController = UIStoryboard(name: HelpStoryboard.storyboardIdentifier, bundle: nil).instantiateInitialViewController()
            break
            
        case .Debug:
            activeViewController = UIStoryboard(name: DebugStoryboard.storyboardIdentifier, bundle: nil).instantiateInitialViewController()
            break
            
        case .RateUs:
            UIApplication.shared.openURL(URL(string : Settings.Constants.AppStoreItemKey)!)
            break
            
        case .ContactUs:
            self.presentFeedback(with: FeedbackOptions(title: "Feedback", body: "Feature request or bug report?"))
            break
            
        case .About:
            activeViewController = AboutViewController.instantiateFromStoryboard(self.storyboard!)
            break;
        }
    }
    
    /**
     Helper method for removing the old child view controller
     - parameter inactiveViewController: the ````UIViewController``` that is to be removed
     */
    fileprivate func removeInactiveViewController() {
        if let inActiveVC = activeViewController {
            inActiveVC.willMove(toParentViewController: nil)
            inActiveVC.view.removeFromSuperview()
            inActiveVC.removeFromParentViewController()
        }
    }
    
    /**
     Helper method for updating the active view controller
     */
    fileprivate func updateActiveViewController(_ viewController: UIViewController?) {
        if let activeVC = viewController {
            addChildViewController(activeVC)
            activeVC.view.frame = containerView.bounds
            containerView.addSubview(activeVC.view)
            activeVC.didMove(toParentViewController: self)
        }
    }
}

extension ContainerViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case .cancelled:
            Log.ln("Mail cancelled")/
        case .saved:
            Log.ln("Mail saved")/
        case .sent:
            Log.ln("Mail sent")/
        case .failed:
            if let error = error {
                Log.error(error as NSError)/
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}
