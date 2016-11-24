//
//  HamburgerButton.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 24/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import QuartzCore

/**
 * HamburgerButton is a sub-class of UIButton, displays a hamburger button
 * and other state button without using image
 *
 * This is a simple button with 2 state. At initialization, it has state "Hamburger"
 * which means 3 lines. After switch state, it has state "Not hamburger" and
 * displays a back button/a close button.
 *
 * This button support 2 type:
 * - BackButton - display <- after switch state
 * - CloseButton - display X after switch state
 *
 * Those type can be setted when initialization or manually at any time/any event.
 *
 */

enum HamburgerButtonType {
    case
    /** Show back (<-) button after switch state/animate. */
    backButton,
    /** Show close (X) button after switch state/animate. */
    closeButton
}

enum HamburgerButtonState {
    case
    /** Initialize state, with 3 lines (hamburger). */
    hamburger,
    /** State happened after animate. */
    notHamburger
}

class HamburgerButton: UIButton {
    /**
     * Current state of hamburger button.
     */
    var hamburgerState = HamburgerButtonState.hamburger
    
    /**
     * Type of hamburger button.
     */
    var hamburgerType = HamburgerButtonType.backButton
    
    /**
     * Time for animation. Default is 0.5f.
     */
    var hamburgerAnimationDuration = 0.5
    
    fileprivate var _lineHeight : CGFloat = 50/6, _lineWidth : CGFloat = 50, _lineSpacing : CGFloat = 5
    fileprivate var _lineCenter : CGPoint
    fileprivate var _lineArray : [ CAShapeLayer ] = []
    fileprivate var _lineCreated = false
    
    // MARK:
    // MARK: Public functions
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(frame:CGRect, type:HamburgerButtonType, lineWidth:CGFloat, lineHeight:CGFloat, lineSpacing:CGFloat, lineCenter:CGPoint, color:UIColor) {
        
        _lineCenter = lineCenter
        
        super.init(frame: frame)
        
        self.setUpHamburger(type: type, lineWidth: lineWidth, lineHeight: lineHeight, lineSpacing: lineSpacing, lineCenter: lineCenter, color: color)
        
    }
    
    func setUpHamburger(type:HamburgerButtonType, lineWidth:CGFloat, lineHeight:CGFloat, lineSpacing:CGFloat, lineCenter:CGPoint, color:UIColor) {
        
        if (_lineCreated) {
            // Lines have been created, do nothing.
            return;
        }
        
        hamburgerType = type
        _lineWidth = lineWidth
        _lineHeight = lineHeight
        _lineSpacing = lineSpacing
        _lineCenter = lineCenter
        
        let topLine = CAShapeLayer(frame: CGRect(x: 0, y: 0, width: lineWidth, height: lineHeight), color: color, position: CGPoint(x: lineCenter.x, y: lineCenter.y - lineHeight - lineSpacing))
        let middleLine = CAShapeLayer(frame: CGRect(x: 0, y: 0, width: lineWidth, height: lineHeight), color: color, position: lineCenter)
        let bottomLine = CAShapeLayer(frame: CGRect(x: 0, y: 0, width: lineWidth, height: lineHeight), color: color, position: CGPoint(x: lineCenter.x, y: lineCenter.y + lineHeight + lineSpacing))
        
        _lineArray = [ topLine, middleLine, bottomLine]
        
        for layer in _lineArray {
            self.layer.addSublayer(layer)
        }
        
        _lineCreated = true;
    }
    
    func switchState() {
        animateButton(forward: hamburgerState == .hamburger)
        hamburgerState = (hamburgerState == .hamburger) ? .notHamburger : .hamburger
    }
    
    // MARK:
    // MARK: Private functions
    
    fileprivate func animateButton(forward:Bool) {
        let anims = [ keyframeAnimations(lineIndex: 0, forward: forward), keyframeAnimations(lineIndex: 1, forward: forward), keyframeAnimations(lineIndex: 2, forward: forward) ]
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(hamburgerAnimationDuration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0))
        
        var index = 0
        for animations in anims {
            let layer = _lineArray[index]
            for anim in animations! {
                if !anim.isRemovedOnCompletion {
                    layer.add(anim, forKey: anim.keyPath)
                } else {
                    layer.addAnimation(anim, value: anim.values!.last as! NSValue, keyPath: anim.keyPath)
                }
            }
            index += 1
        }
        CATransaction.commit()
    }
    
    fileprivate func keyframeAnimations(lineIndex:Int, forward:Bool) -> [CAKeyframeAnimation]? {
        switch hamburgerType {
        case .backButton:
            switch lineIndex {
            case 0:
                let animRotate = CAKeyframeAnimation(keyPath: "transform.rotation")
                animRotate.values = forward ? [ 0, (M_PI*5/4) ] : [ (M_PI*5/4), 0]
                animRotate.calculationMode = kCAAnimationCubic
                animRotate.keyTimes = [ 0, 0.33, 0.73, 1.0]
                
                let startPoint = forward ? CGPoint(x: _lineCenter.x, y: _lineCenter.y - _lineHeight - _lineSpacing) : CGPoint(x: _lineCenter.x - scale(10), y: _lineCenter.y + _lineHeight + scale(7.2))
                let endPoint = forward ? CGPoint(x: _lineCenter.x - scale(10), y: _lineCenter.y + _lineHeight + scale(7.2)) : CGPoint(x: _lineCenter.x, y: _lineCenter.y - _lineHeight - _lineSpacing)
                let controlPoint = CGPoint(x: _lineCenter.x + scale(15), y: _lineCenter.y)
                
                let animPosition = CAKeyframeAnimation(keyPath: "position")
                animPosition.path = UIBezierPath.animateBezierPath(startPoint: startPoint, endPoint: endPoint, controlPoint: controlPoint).cgPath
                animPosition.isRemovedOnCompletion = false
                animPosition.fillMode = kCAFillModeForwards
                
                return [ animRotate, animPosition ]
            case 1:
                let animRotate = CAKeyframeAnimation(keyPath: "transform.rotation")
                animRotate.values = forward ? [ 0, (M_PI) ] : [ (M_PI), 0]
                
                return [ animRotate ]
            case 2:
                let animRotate = CAKeyframeAnimation(keyPath: "transform.rotation")
                animRotate.values = forward ? [ 0, (-M_PI*5/4) ] : [ (-M_PI*5/4), 0]
                animRotate.calculationMode = kCAAnimationCubic
                animRotate.keyTimes = [ 0, 0.33, 0.73, 1.0]
                
                let startPoint = forward ? CGPoint(x: _lineCenter.x, y: _lineCenter.y + _lineHeight + _lineSpacing) : CGPoint(x: _lineCenter.x - scale(10), y: _lineCenter.y - _lineHeight - scale(7.2))
                let endPoint = forward ? CGPoint(x: _lineCenter.x - scale(10), y: _lineCenter.y - _lineHeight - scale(7.2)) : CGPoint(x: _lineCenter.x, y: _lineCenter.y + _lineHeight + _lineSpacing)
                let controlPoint = CGPoint(x: _lineCenter.x + scale(15), y: _lineCenter.y)
                
                let animPosition = CAKeyframeAnimation(keyPath: "position")
                animPosition.path = UIBezierPath.animateBezierPath(startPoint: startPoint, endPoint: endPoint, controlPoint: controlPoint).cgPath
                animPosition.isRemovedOnCompletion = false
                animPosition.fillMode = kCAFillModeForwards
                
                return [ animRotate, animPosition ]
            default:
                return nil
            }
        case .closeButton:
            switch lineIndex {
            case 0:
                let animRotate = CAKeyframeAnimation(keyPath: "transform.rotation")
                animRotate.values = forward ? [ 0, (-M_PI*5/4) ] : [ (-M_PI*5/4), 0]
                animRotate.calculationMode = kCAAnimationCubic
                animRotate.keyTimes = [ 0, 0.33, 0.73, 1.0]
                
                let startPoint = forward ? CGPoint(x: _lineCenter.x, y: _lineCenter.y - _lineHeight - _lineSpacing) : _lineCenter
                let endPoint = forward ? _lineCenter : CGPoint(x: _lineCenter.x, y: _lineCenter.y - _lineHeight - _lineSpacing)
                let controlPoint = CGPoint(x: _lineCenter.x + scale(20), y: _lineCenter.y - _lineHeight - scale(5))
                
                let animPosition = CAKeyframeAnimation(keyPath: "position")
                animPosition.path = UIBezierPath.animateBezierPath(startPoint: startPoint, endPoint: endPoint, controlPoint: controlPoint).cgPath
                animPosition.isRemovedOnCompletion = false
                animPosition.fillMode = kCAFillModeForwards
                
                return [ animRotate, animPosition ]
            case 1:
                let animRotate = CAKeyframeAnimation(keyPath: "transform.rotation")
                animRotate.values = forward ? [ 0, (M_PI) ] : [ (M_PI), 0]
                
                let animScale = CAKeyframeAnimation(keyPath: "transform.scale.x")
                animScale.values = forward ? [ 1, 0.1 ] : [ 0.1, 1 ]
                
                return [ animRotate, animScale ]
            case 2:
                let animRotate = CAKeyframeAnimation(keyPath: "transform.rotation")
                animRotate.values = forward ? [ 0, (M_PI*5/4) ] : [ (M_PI*5/4), 0]
                animRotate.calculationMode = kCAAnimationCubic
                animRotate.keyTimes = [ 0, 0.33, 0.73, 1.0]
                
                let startPoint = forward ? CGPoint(x: _lineCenter.x, y: _lineCenter.y + _lineHeight + _lineSpacing) : _lineCenter
                let endPoint = forward ? _lineCenter : CGPoint(x: _lineCenter.x, y: _lineCenter.y + _lineHeight + _lineSpacing)
                let controlPoint = CGPoint(x: _lineCenter.x - scale(20), y: _lineCenter.y + _lineHeight + scale(5))
                
                let animPosition = CAKeyframeAnimation(keyPath: "position")
                animPosition.path = UIBezierPath.animateBezierPath(startPoint: startPoint, endPoint: endPoint, controlPoint: controlPoint).cgPath
                animPosition.isRemovedOnCompletion = false
                animPosition.fillMode = kCAFillModeForwards
                
                return [ animRotate, animPosition ]
            default:
                return nil
            }
        }
    }
    fileprivate func scale(_ value:CGFloat) -> CGFloat {
        return value/(50/_lineWidth)
    }
}

// MARK:

// MARK: Supporting Extension
// MARK:

// MARK: CAShapeLayer extension

extension CAShapeLayer {
    convenience init(frame:CGRect, color:UIColor, position:CGPoint) {
        
        self.init()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: frame.size.width, y: 0))
        
        self.path = path.cgPath
        self.lineWidth = frame.size.height
        self.strokeColor = color.cgColor
        
        let bound : CGPath = CGPath(__byStroking: self.path!, transform: nil, lineWidth: self.lineWidth, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.miter, miterLimit: self.miterLimit)!
        self.bounds = bound.boundingBox
        
        self.position = position
    }
}

// MARK: CALayer extension
extension CALayer {
    
    func addAnimation(_ anim:CAAnimation!, value:NSValue!, keyPath:String!) {
        self.add(anim, forKey: keyPath)
        self.setValue(value, forKeyPath: keyPath)
    }
}

// MARK: UIBezierPath extension
extension UIBezierPath {
    
    class func animateBezierPath(startPoint:CGPoint, endPoint:CGPoint, controlPoint:CGPoint) -> UIBezierPath {
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        return path
    }
}

