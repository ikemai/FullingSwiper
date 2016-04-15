//
//  ViewController.swift
//  FullingSwiper
//
//  Created by ikemai on 03/04/2016.
//  Copyright (c) 2016 ikemai. All rights reserved.
//

import UIKit
import FullingSwiper

class ViewController: SumpleViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Brown"
        pushViewController = RedViewController()
        addPushButton(UIColor.brownColor(), buttonColor: UIColor.whiteColor())
    }
}

class RedViewController: SumpleViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "RED"
        pushViewController = BlueViewController()
        addPushButton(UIColor.redColor(), buttonColor: UIColor.whiteColor())
    }
}

class BlueViewController: SumpleViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "BLUE"
        pushViewController = ViewController()
        addPushButton(UIColor.blueColor(), buttonColor: UIColor.whiteColor())
    }
}

class SumpleViewController: UIViewController {
    
    var pushViewController: SumpleViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* 
        fullSwiperStack
        .set(navigationController: navigationController)
        */
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /** When you support iOS8, Please do not set fullingSwiper in viewWillAppear
        if let navigationController = navigationController {
            fullingSwiper
                .set(navigationController: navigationController)
                .hideRatio(0.3)
                .animateDuration(0.15)
                .animateScale(0.95)
        }
        */
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // When You set `stack view` more than two, Please set `fullingSwiper.reset()` by all means in `viewDidAppear`
        fullingSwiper.reset()
    }
    
    func addPushButton(bg: UIColor, buttonColor: UIColor) {
        view.backgroundColor = bg
        
        let button = UIButton(frame: CGRectMake(0,0,100,50))
        button.backgroundColor = buttonColor
        button.layer.masksToBounds = true
        button.setTitle("Push", forState: .Normal)
        button.setTitleColor(bg, forState: .Normal)
        button.layer.cornerRadius = 20
        button.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        button.addTarget(self, action: "onClickPushButton:", forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }
    
    func onClickPushButton(sender: UIButton) {
        if let pushView = pushViewController, navigationController = navigationController {
            pushView.fullingSwiper
                .set(navigationController: navigationController)
                .poping() { _ in
                    print("****** Poping!")
                }
                .shouldBeginGesture() { _ in
                    print("****** shouldBeginGesture!")
                }
                .completed() { _ in
                    print("****** completed!")
            }
            navigationController.pushViewController(pushView, animated: true)
        }
    }
}
