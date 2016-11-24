//
//  OnboardingMainViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 28/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import AVFoundation

protocol OnboardingMainViewControllerDelegate: class {
    func nextPageRequested()
}

final class OnboardingMainViewController: UIViewController {
    
    weak var delegate: OnboardingMainViewControllerDelegate?
    fileprivate(set) var presentedPage: OnboardingPage!
    
    @IBOutlet fileprivate(set) weak var nextButton: UIButton!
    @IBOutlet fileprivate(set) weak var containerView: UIView!
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Setup
    fileprivate func setupUI() {
        if let pageViewController = self.storyboard?.instantiateViewController(withIdentifier: OnboardingPageViewController.storyboardIdentifier) as? OnboardingPageViewController  {
            addChildViewController(pageViewController)
            pageViewController.page.didChange.addHandler(self, handler: OnboardingMainViewController.pageDidChange)
            presentedPage = pageViewController.page.value
            pageViewController.view.frame = containerView.bounds
            containerView.addSubview(pageViewController.view)
            pageViewController.didMove(toParentViewController: self)
        }
    }
    
    // MARK: Observer
    fileprivate func pageDidChange(_ oldValue: OnboardingPage, newValue: OnboardingPage) {
        presentedPage = newValue
        (newValue == .cameraPermission && !Permissions.camera.hasPermission) || (newValue == .third && Permissions.camera.hasPermission) ? nextButton.setTitle("OK", for: UIControlState()) : nextButton.setTitle("NEXT", for: UIControlState())
        Log.ln("🤖 \(type(of: newValue)) changed: \(newValue)")/
    }
    
    // MARK: Private Helper
    fileprivate func askForCameraPermission() {
        Permissions.camera.request(self) { [unowned self] (success) in
            Settings.registerOnboarding(true)
            self.proceedToMainViewController()
        }
    }
    
    fileprivate func proceedToMainViewController() {
        let storyboard = UIStoryboard(name: MainStoryboard.storyboardIdentifier, bundle: nil)
        self.present(storyboard.instantiateInitialViewController()!, animated: true, completion: nil)
    }

    // MARK: Action
    @IBAction fileprivate func nextButtonTouchedUpInside(_ sender: AnyObject) {
        ((presentedPage == .cameraPermission && !Permissions.camera.hasPermission) || (presentedPage == .third && Permissions.camera.hasPermission) ) ? askForCameraPermission() : delegate?.nextPageRequested()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
