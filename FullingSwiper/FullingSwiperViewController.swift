//
//  FullingSwiperViewController.swift
//  FullingSwiper
//
//  Created by Mai Ikeda on 2016/03/04.
//  Copyright © 2016年 mai_ikeda. All rights reserved.
//

import UIKit

public class FullingSwiperViewController: UIViewController {
    
    private(set) var transition: FullingSwiperTransition?
    private(set) var beforeDelegate: UINavigationControllerDelegate?
    
    weak private var navigation: UINavigationController?
    weak private var panGesture: UIPanGestureRecognizer?
    
    deinit {
        initialize()
    }
    
    /**
     @param completed timing is popViewController. Default is nil
     */
    public func set(navigationController navigation: UINavigationController) -> FullingSwiperViewController {
        initialize()
        self.navigation = navigation
        beforeDelegate = navigation.delegate
        transition = FullingSwiperTransition()
        
        addGesture()
        
        poping(nil)
        shouldBeginGesture(nil)
        completed(nil)
        
        navigation.delegate = transition
        return self
    }
    
    public func initialize() {
        navigation?.delegate = beforeDelegate
        removeGesture()
        beforeDelegate = nil
        transition?.removeHandlers()
        transition = nil
    }
}

// MARK: - Set closures
extension FullingSwiperViewController {
    /**
     set start `popViewController` handler
     */
    public func poping(popHandler: (() -> Void)?) -> FullingSwiperViewController  {
        transition?.popHandler = { [weak self] _ in
            popHandler?()
            self?.navigation?.popViewControllerAnimated(true)
        }
        return self
    }
    
    /**
     set shouldBeginGesture handler
     */
    public func shouldBeginGesture(shouldBeginGestureHandler: (() -> Void)?) -> FullingSwiperViewController  {
        transition?.shouldBeginGestureHandler = { [weak self] _ in
            shouldBeginGestureHandler?()
            return (self?.navigation?.viewControllers.count ?? 0 ) > 1
        }
        return self
    }
    
    /**
     set completed handler
     */
    public func completed(completed: (() -> Void)?) -> FullingSwiperViewController  {
        transition?.completed = { [weak self] in
            self?.initialize()
            completed?()
        }
        return self
    }
}

// MARK: - Set paramators
extension FullingSwiperViewController {
    
    /**
     @param: hideRatio is the value that less than hideRatio cancel pop. Default is 0.2.
     */
    public func hideRatio(ratio: CGFloat) -> FullingSwiperViewController  {
        transition?.hideRatio = ratio
        return self
    }
    
    /**
     @param: duration is the time when (pop or push) animation. Default is 0.3.
     */
    public func animateDuration(duration: NSTimeInterval) -> FullingSwiperViewController  {
        transition?.animateDuration = duration
        return self
    }
    
    /**
     @param: scale is under view scale when (pop or push) animation. Default is 1.
     */
    public func animateScale(scale: CGFloat) -> FullingSwiperViewController  {
        transition?.scale = scale
        return self
    }
}

// MARK: - Private
private extension FullingSwiperViewController {
    
    func addGesture() {
        removeGesture()
        if let view = navigation?.view, gesture = transition?.createGesture() {
            panGesture = gesture
            view.addGestureRecognizer(gesture)
        }
    }
    
    func removeGesture() {
        if let gesture = panGesture {
            navigation?.view.removeGestureRecognizer(gesture)
        }
        panGesture = nil
    }
}
