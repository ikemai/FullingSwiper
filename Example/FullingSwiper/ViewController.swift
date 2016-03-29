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
    
    deinit {
        print("deinit : ViewController ---------")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushViewController = RedViewController()
        addPushButton(UIColor.brownColor(), buttonColor: UIColor.whiteColor())
    }
}

class RedViewController: SumpleViewController {
    
    deinit {
        print("deinit : RedViewController ---------")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushViewController = BlueViewController()
        addPushButton(UIColor.redColor(), buttonColor: UIColor.whiteColor())
    }
}

class BlueViewController: SumpleViewController {
    
    deinit {
        print("deinit : BlueViewController ---------")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func addPushButton(bg: UIColor, buttonColor: UIColor) {
        view.backgroundColor = bg
        
        let button = UIButton(frame: CGRectMake(0,0,100,50))
        button.backgroundColor = buttonColor
        button.layer.masksToBounds = true
        button.setTitle("Push", forState: .Normal)
        button.setTitleColor(bg, forState: .Normal)
        button.layer.cornerRadius = 20
        button.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        button.addTarget(self, action: #selector(SumpleViewController.onClickPushButton), forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }
    
    func onClickPushButton(sender: UIButton) {
        if let pushView = pushViewController, navigationController = navigationController {
            pushView.fullingSwiper
                .set(navigationController: navigationController)
            .hideRatio(0.3)
            .animateDuration(0.3)
            .animateScale(0.95)
            
            navigationController.pushViewController(pushView, animated: true)
        }
    }
}
