//
//  CenterViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/24/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

enum SlideOutState {
    case collapsed
    case leftPanelExpanded
}

protocol CenterViewConrtollerDelegate: class {
    func itemSelected(_ item: SidePanelOption)
}

final class CenterViewConrtoller: UIViewController {
    
    // MARK: Properties
    
    weak var delegate: CenterViewConrtollerDelegate?
    
    /// Property for storing a reference to the current active view controller. When the value is charged it invokes two methods for removing the old and adding the new child view controller
    lazy var centerNavigationController: UINavigationController = {
        let _centerNavigationController: UINavigationController  = UINavigationController(rootViewController: self.containerViewController)
        return _centerNavigationController
    }()
    
    lazy var containerViewController: UIViewController = {
        let _containerViewController: ContainerViewController  = self.storyboard!.instantiateViewController(withIdentifier: ContainerViewController.storyboardIdentifier) as!ContainerViewController
        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpace.width = -10.0
        let leftButton = UIBarButtonItem(customView: self.hamburgerButton)
        leftButton.target = self
        self.hamburgerButton.addTarget(self, action: #selector(CenterViewConrtoller.showSideMenuButtonTouchedUpInside(_:)), for: .touchUpInside)
        leftButton.action = #selector(CenterViewConrtoller.showSideMenuButtonTouchedUpInside)
        _containerViewController.navigationItem.leftBarButtonItems = [negativeSpace, leftButton /* this will be the button which you actually need */]
        self.delegate = _containerViewController
        return _containerViewController
    }()
    
    lazy var leftViewController: SidePanelViewController = {
        let _leftViewController = self.storyboard!.instantiateViewController(withIdentifier: SidePanelViewController.storyboardIdentifier) as! SidePanelViewController
        _leftViewController.delegate = self
        return _leftViewController
    }()
    
    lazy var hamburgerButton: HamburgerButton = {
        let _hamburgerButton = HamburgerButton(frame: CGRect(x: 0,y: 0,width: 40,height: 40), type: HamburgerButtonType.backButton, lineWidth: 25, lineHeight: 25/6, lineSpacing: 5, lineCenter: CGPoint(x: 20, y: 20), color: UIColor.white)
        _hamburgerButton.hamburgerType = .closeButton
        return _hamburgerButton
    }()

    
    var currentState: SlideOutState = .collapsed {
        didSet {
            let shouldShowShadow = currentState != .collapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        centerNavigationController.didMove(toParentViewController: self)
//        self.addPanGestureRecognizer()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Setup
    
    fileprivate func addPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CenterViewConrtoller.handlePanGesture(_:)))
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.cancelsTouchesInView = false
    }
    
    // MARK: Actions
    
    internal func showSideMenuButtonTouchedUpInside(_ sender: HamburgerButton) {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(notAlreadyExpanded)
    }
}

extension CenterViewConrtoller {
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        addChildSidePanelController(leftViewController)
    }
    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        view.insertSubview(sidePanelController.view, at: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    func animateLeftPanel(_ shouldExpand: Bool) {
        if (shouldExpand) {
            self.hamburgerButton.switchState()
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(centerNavigationController.view.frame.width - centerPanelExpandedOffset)
        } else {
            self.hamburgerButton.switchState()
            animateCenterPanelXPosition(0) { finished in
                self.currentState = .collapsed
                self.leftViewController.view.removeFromSuperview()
            }
        }
    }
    
    func animateCenterPanelXPosition(_ targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

extension CenterViewConrtoller: SidePanelViewControllerDelegate {
    func itemSelected(_ item: SidePanelOption) {
        collapseSidePanels()
        self.delegate?.itemSelected(item)
    }
}

extension CenterViewConrtoller: UIGestureRecognizerDelegate {
    // MARK: Gesture recognizer
    
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        let gestureForRightPanel = (recognizer.translation(in: view).x < 0)
        if gestureForRightPanel {
            return
        }
        
        switch(recognizer.state) {
        case .began:
            if (currentState == .collapsed) {
                if (gestureIsDraggingFromLeftToRight) {
                    addLeftPanelViewController()
                }
                showShadowForCenterViewController(true)
            }
        case .changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translation(in: view).x
            recognizer.setTranslation(CGPoint.zero, in: view)
        case .ended:
            // animate the side panel open or closed based on whether the view has moved more or less than halfway
            let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
            animateLeftPanel(hasMovedGreaterThanHalfway)
        default:
            break
        }
    }
}

