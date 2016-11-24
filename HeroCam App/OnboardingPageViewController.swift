//
//  OnboardingPageViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 28/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

enum OnboardingPage: Int {
    case first, second, third, cameraPermission
    var storyboardIdentifier: String {
        switch self {
        case .first: return "OnboardingFirstViewController"
        case .second: return "OnboardingSecondViewController"
        case .third: return "OnboardingThirdViewController"
        case .cameraPermission: return "OnboardingFourthViewController"
        }
    }
}

final class OnboardingPageViewController: UIPageViewController {
    
    var page: Observable<OnboardingPage> = Observable(.first)

    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        dataSource = self
        let parent = self.parent as? OnboardingMainViewController
        parent?.delegate = self
        removeUserScolling()
        setViewControllers([getStepOne()], direction: .forward, animated: false, completion: nil)
    }
    
    // MARK: Private
    
    fileprivate func getStepOne() -> UIViewController {
        return storyboard!.instantiateViewController(withIdentifier: OnboardingPage.first.storyboardIdentifier)
    }
    
    fileprivate func getStepTwo() -> UIViewController {
        return storyboard!.instantiateViewController(withIdentifier: OnboardingPage.second.storyboardIdentifier)
    }
    
    fileprivate func getStepThree() -> UIViewController {
        return storyboard!.instantiateViewController(withIdentifier: OnboardingPage.third.storyboardIdentifier)
    }
    
    fileprivate func getStepFour() -> UIViewController {
        return storyboard!.instantiateViewController(withIdentifier: OnboardingPage.cameraPermission.storyboardIdentifier)
    }
    
    fileprivate func changePage(_ direction: UIPageViewControllerNavigationDirection) {
        if let pageContentViewController = self.viewControllers?.first, let nextViewController = self.pageViewController(self, viewControllerAfter: pageContentViewController), let nextPage = OnboardingPage(rawValue: page.value.rawValue + 1)  {
            page <- nextPage
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        } else {
            assert(false, "\(type(of: self)) error detected while changing page")
        }
    }
    
    func removeUserScolling() {
        let scrollView: UIScrollView = self.view.subviews.filter { return $0 is UIScrollView }.first as! UIScrollView
        scrollView.isScrollEnabled = false
    }
}

extension OnboardingPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        assert(false, "There is no back functionallity on the onboarding")
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: OnboardingFirstViewController.self) {
            // 0 -> 1
            return getStepTwo()
        } else if viewController.isKind(of: OnboardingSecondViewController.self) {
            // 1 -> 2
            return getStepThree()
        } else if viewController.isKind(of: OnboardingThirdViewController.self) && !Permissions.camera.hasPermission {
            // 2 -> 3
            return getStepFour()
        } else {
            // 3 -> end of the road
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension OnboardingPageViewController: OnboardingMainViewControllerDelegate {
    func nextPageRequested() {
        changePage(.forward)
    }
}
