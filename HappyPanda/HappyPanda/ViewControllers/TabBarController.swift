//
//  TabbarController.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import ESTabBarController_swift


class TabBarController: BaseTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.clear
        tabBar.tintColor = UIColor.clear
        customRemindStyle()
        
    }

    func customRemindStyle() {
        let v1 = R.storyboard.main.corridorsController()!
        let v2 = R.storyboard.main.trajectoryController()!
        v1.tabBarItem = ESTabBarItem.init(title: "回廊", image: nil, selectedImage: nil)
        v2.tabBarItem = ESTabBarItem.init(title: "轨迹", image: nil, selectedImage: nil)

        viewControllers = [v1, v2]
    }
}
