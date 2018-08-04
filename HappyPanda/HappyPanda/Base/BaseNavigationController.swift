//
//  BaseNavigationController.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

 
    override var shouldAutorotate: Bool{
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return super.preferredInterfaceOrientationForPresentation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer!.isEnabled = true
        isNavigationBarHidden = true
    }


}
