//
//  OnboardingFourthViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 10/6/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

final class OnboardingFourthViewController: UIViewController {
    
    @IBAction func notNowButtonTouchedUpInside(_ sender: AnyObject) {
        Settings.registerOnboarding(true)
        let storyboard = UIStoryboard(name: MainStoryboard.storyboardIdentifier, bundle: nil)
        self.present(storyboard.instantiateInitialViewController()!, animated: true, completion: nil)
    }
}
