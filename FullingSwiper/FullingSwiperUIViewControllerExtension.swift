//
//  FullingSwiperUIViewControllerExtension.swift
//  FullingSwiper
//
//  Created by Mai Ikeda on 2016/03/04.
//  Copyright © 2016年 mai_ikeda. All rights reserved.
//

import UIKit

var fullingSwiperStackKey = "fullingSwiperStackAssociation"

extension UIViewController {
    
    public var fullingSwiper: FullingSwiperViewController {
        get {
            if let instance = objc_getAssociatedObject(self, &fullingSwiperStackKey) as? FullingSwiperViewController {
                return instance
            }
            let instance = FullingSwiperViewController()
            objc_setAssociatedObject(self, &fullingSwiperStackKey, instance, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return instance
        }
    }
}