//
//  FullingSwiperTransition.swift
//  FullingSwiper
//
//  Created by Mai Ikeda on 2016/03/04.
//  Copyright © 2016年 mai_ikeda. All rights reserved.
//

import UIKit

class FullingSwiperTransition: UIPercentDrivenInteractiveTransition {
    
    // Closures
    var popHandler: (() -> Void)?
    var completed: (() -> Void)?
    var shouldBeginGestureHandler: ((UIGestureRecognizer) -> Bool)?
    
    // Can set paramators
    // duration is the time when (pop or push) animation. Default is 0.3.
    var animateDuration: NSTimeInterval = 0.3
    // hideRatio is the value that less than hideRatio cancel pop. Default is 0.2.
    var hideRatio: CGFloat = 0.2
    // scale is under view scale when (pop or push) animation. Default is 1.
    var scale: CGFloat = 1
    
    // Animation
    private var operation: UINavigationControllerOperation = .None
    
    // Gesture
    private var gestureBeginX: CGFloat = 0
    private var beforeX = BeforeX(first: 0, last: 0)
    private var poping = false
    
    func removeHandlers() {
        popHandler =  nil
        completed =  nil
        shouldBeginGestureHandler =  nil
    }
    
    func createGesture() -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(FullingSwiperTransition.fullingSwiperPanGesture))
        gesture.delegate = self
        return gesture
    }
}

// MARK: - Struct
extension FullingSwiperTransition {
    
    struct BeforeX {
        let first: CGFloat
        let last: CGFloat
        
        init(first: CGFloat, last: CGFloat) {
            self.first = first
            self.last = last
        }
    }
}

// MARK: - Gesture
extension FullingSwiperTransition: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldBeginGestureHandler?(gestureRecognizer) ?? true
    }
    
    func fullingSwiperPanGesture(gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        switch gesture.state {
        case .Began:
            let rightDirection = gesture.translationInView(view).x >= 0
            poping = rightDirection
            
            guard rightDirection else { return }
            gestureBeginX = gesture.locationInView(view).x
            popHandler?()
            
        case .Changed:
            guard poping else { return }
            
            let distanceX = gesture.locationInView(view).x - gestureBeginX
            let ratio = distanceX / view.bounds.width
            let percentComplete = max(0, min(1, ratio))
            
            updateInteractiveTransition(percentComplete)
            
        case .Ended, .Cancelled, .Failed:
            guard poping else { return }
            
            let hidableX = view.bounds.width * hideRatio
            let x = gesture.locationInView(view).x
            let distanceX = x - gestureBeginX
            let reversed = beforeX.first > x
            
            if distanceX > hidableX && reversed == false {
                finishInteractiveTransition()
                completed?()
            } else {
                cancelInteractiveTransition()
            }
            beforeX = BeforeX(first: 0, last: 0)
            gestureBeginX = 0
            poping = false
            
        default:
            break
        }
        if poping {
            let first = beforeX.last
            beforeX = BeforeX(first: first, last: gesture.locationInView(view).x)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension FullingSwiperTransition: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.operation = operation
        return self
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return poping ? self : nil
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension FullingSwiperTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animateDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            containerView = transitionContext.containerView() else { return }
        
        let isPop = (operation == .Pop)
        let toView = isPop ? fromViewController.view : toViewController.view
        let fromView = isPop ? toViewController.view : fromViewController.view
        
        // toView
        let toViewMaxX: CGFloat = containerView.frame.width
        toView.frame = containerView.bounds
        toView.transform = isPop ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(toViewMaxX, 0)
        let shadow = shadowView(containerView.bounds.height)
        toView.addSubview(shadow)
        
        // fromView
        let scale = self.scale
        fromView.frame = containerView.bounds
        let framViewMinX = -(fromView.bounds.width / 4)
        fromView.transform = isPop ? CGAffineTransformMakeTranslation(framViewMinX, 0) : CGAffineTransformIdentity
        if scale != 1 {
            fromView.transform = isPop ? CGAffineTransformMakeScale(scale, scale) : CGAffineTransformIdentity
        }
        
        // containerView
        let overlayView = UIView(frame: containerView.bounds)
        containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        if isPop {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            overlayView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
            fromView.addSubview(overlayView)
        }
        
        UIView.animateWithDuration(animateDuration,
            delay: 0,
            options: .CurveLinear,
            animations: { [weak shadow, weak toView, weak fromView, weak overlayView] in
                toView?.transform = isPop ? CGAffineTransformMakeTranslation(toViewMaxX, 0) : CGAffineTransformIdentity
                fromView?.transform = isPop ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(framViewMinX, 0)
                shadow?.alpha = isPop ? 0 : 1
                if scale != 1 {
                    fromView?.transform = isPop ? CGAffineTransformIdentity : CGAffineTransformMakeScale(scale, scale)
                }
                if isPop {
                    overlayView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
                }
            }, completion: { [weak shadow, weak toView, weak fromView, weak overlayView, weak transitionContext] _ in
                toView?.transform = CGAffineTransformIdentity
                fromView?.transform = CGAffineTransformIdentity
                
                let completed = transitionContext?.transitionWasCancelled() == false
                transitionContext?.completeTransition(completed)
                
                shadow?.removeFromSuperview()
                overlayView?.removeFromSuperview()
        })
    }
}

// MARK: - Private method, for shadow view
private extension FullingSwiperTransition {
    
    func shadowView(height: CGFloat) -> UIView {
        let shadowWidth: CGFloat = 10
        let shadow = UIView(frame: CGRect(x: -shadowWidth, y: 0, width: shadowWidth, height: height))
        insertLayerVerticallyGradient(shadow)
        return shadow
    }
    
    func insertLayerVerticallyGradient(view: UIView) {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        
        let color = UIColor.blackColor()
        layer.colors = [
            color.colorWithAlphaComponent(0.3).CGColor,
            color.colorWithAlphaComponent(0.2).CGColor,
            color.colorWithAlphaComponent(0.05).CGColor,
            color.colorWithAlphaComponent(0).CGColor
        ]
        layer.locations = [0, 0.1, 0.5, 1]
        
        layer.startPoint = CGPointMake(1, 0.5)
        layer.endPoint = CGPointMake(0, 0.5)
        
        view.layer.insertSublayer(layer, atIndex: 0)
    }
}
