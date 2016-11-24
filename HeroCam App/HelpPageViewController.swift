//
//  HelpPageViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 28/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

class HelpPageViewController: UIPageViewController {
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        dataSource = self
        setViewControllers([getStepOne()], direction: .forward, animated: false, completion: nil)
    }
    
    // MARK: Private
    
    fileprivate lazy var onboardingStoryboard: UIStoryboard = {
        return UIStoryboard(name: OnboardingStoryboard.storyboardIdentifier, bundle: nil)
    }()
    
    fileprivate func getStepOne() -> OnboardingFirstViewController {
        return onboardingStoryboard.instantiateViewController(withIdentifier: OnboardingFirstViewController.storyboardIdentifier) as! OnboardingFirstViewController
    }
    
    fileprivate func getStepTwo() -> OnboardingSecondViewController {
        return onboardingStoryboard.instantiateViewController(withIdentifier: OnboardingSecondViewController.storyboardIdentifier) as! OnboardingSecondViewController
    }
    
    fileprivate func getStepThree() -> OnboardingThirdViewController {
        return onboardingStoryboard.instantiateViewController(withIdentifier: OnboardingThirdViewController.storyboardIdentifier) as! OnboardingThirdViewController
    }
}

extension HelpPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: OnboardingFirstViewController.self) {
            // 1 -> 0
            return nil
        } else if viewController.isKind(of: OnboardingSecondViewController.self) {
            // 2 -> 1
            return getStepOne()
        } else if viewController.isKind(of: OnboardingThirdViewController.self) {
            // 3 -> 2
            return getStepTwo()
        } else {
            // end of the road -> 3
            return getStepThree()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: OnboardingFirstViewController.self) {
            // 0 -> 1
            return getStepTwo()
        } else if viewController.isKind(of: OnboardingSecondViewController.self) {
            // 1 -> 2
            return getStepThree()
        } else {
            // 2 -> end of the road
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
