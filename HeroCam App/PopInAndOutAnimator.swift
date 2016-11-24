//
//  PopInAndOutAnimator.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 10/3/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

final class PopInAndOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate let _operationType : UINavigationControllerOperation
    fileprivate let _transitionDuration : TimeInterval
    
    init(operation: UINavigationControllerOperation) {
        _operationType = operation
        _transitionDuration = 0.4
    }
    
    init(operation: UINavigationControllerOperation, andDuration duration: TimeInterval) {
        _operationType = operation
        _transitionDuration = duration
    }
    
    //MARK: Push and Pop animations performers
    internal func performPushTransition(withTransitionContext transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            // Something really bad happend and it is not possible to perform the transition
            Log.ln("ERROR: Transition impossible to perform since either the destination view or the conteiner view are missing!")/
            return
        }
        
        let container = transitionContext.containerView
        
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.childViewControllers.first as? CollectionPushAndPoppable,
            let fromView = fromViewController.collectionView,
            let currentCell = fromViewController.sourceCell else {
                // There are not enough info to perform the animation but it is still possible
                // to perform the transition presenting the destination view
                container.addSubview(toView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        
        // Add to container the destination view
        container.addSubview(toView)
        
        // Prepare the screenshot of the destination view for animation
        let screenshotToView =  UIImageView(image: toView.screenshot(with: ColorPalette.gray.extraLight))
        // set the frame of the screenshot equals to the cell's one
        screenshotToView.frame = currentCell.frame
        // Now I get the coordinates of screenshotToView inside the container
        let containerCoord = fromView.convert(screenshotToView.frame.origin, to: container)
        // set a new origin for the screenshotToView to overlap it to the cell
        screenshotToView.frame.origin = containerCoord
        
        // Prepare the screenshot of the source view for animation
        let screenshotFromView = UIImageView(image: currentCell.screenshot(with: ColorPalette.gray.extraLight))
        screenshotFromView.frame = screenshotToView.frame
        
        // Add screenshots to transition container to set-up the animation
        container.addSubview(screenshotToView)
        container.addSubview(screenshotFromView)
        
        // Set views initial states
        toView.isHidden = true
        screenshotToView.isHidden = true
        
        // Delay to guarantee smooth effects
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.08 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            screenshotToView.isHidden = false
        }
        
        UIView.animate(withDuration: _transitionDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { 
            screenshotFromView.alpha = 0.0
            screenshotToView.frame = UIScreen.main.bounds
            screenshotToView.frame.origin = CGPoint(x: 0.0, y: 0.0)
            screenshotFromView.frame = screenshotToView.frame
            }) { (_) in
                screenshotToView.removeFromSuperview()
                screenshotFromView.removeFromSuperview()
                toView.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
    
    internal func performPopTransition(withTransitionContext transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            // Something really bad happend and it is not possible to perform the transition
            Log.ln("ERROR: Transition impossible to perform since either the destination view or the conteiner view are missing!")/
            return
        }
        
        let container = transitionContext.containerView
        
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.childViewControllers.first as? CollectionPushAndPoppable,
            let toCollectionView = toViewController.collectionView,
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromViewController.view,
            let currentCell = toViewController.sourceCell else {
                // There are not enough info to perform the animation but it is still possible
                // to perform the transition presenting the destination view
                container.addSubview(toView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        
        // Add destination view to the container view
        container.addSubview(toView)
        
        // Prepare the screenshot of the source view for animation
        let screenshotFromView = UIImageView(image: fromView.screenshot(with: ColorPalette.gray.extraLight))
        screenshotFromView.frame = fromView.frame
        
        // Prepare the screenshot of the destination view for animation
        let screenshotToView = UIImageView(image: currentCell.screenshot(with: ColorPalette.gray.extraLight))
        screenshotToView.frame = screenshotFromView.frame
        
        // Add screenshots to transition container to set-up the animation
        container.addSubview(screenshotToView)
        container.insertSubview(screenshotFromView, belowSubview: screenshotToView)
        
        // Set views initial states
        screenshotToView.alpha = 0.0
        fromView.isHidden = true
        currentCell.isHidden = true
        
        let containerCoord = toCollectionView.convert(CGPoint(x: currentCell.frame.origin.x, y: currentCell.frame.origin.y + 128), from: container)
        UIView.animate(withDuration: _transitionDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            screenshotToView.alpha = 1.0
            screenshotFromView.frame = currentCell.frame
            screenshotFromView.frame.origin = containerCoord
            screenshotToView.frame = screenshotFromView.frame
            
        }) { _ in
            
            currentCell.isHidden = false
            screenshotFromView.removeFromSuperview()
            screenshotToView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    //MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return _transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if _operationType == .push {
            performPushTransition(withTransitionContext: transitionContext)
        } else if _operationType == .pop {
            performPopTransition(withTransitionContext: transitionContext)
        }
    }
}
