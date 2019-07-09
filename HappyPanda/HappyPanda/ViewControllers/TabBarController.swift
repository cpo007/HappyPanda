//
//  TabbarController.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import ViewDeck


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
        let deck = IIViewDeckController.init(center: v1, rightViewController: nil)

        deck.tabBarItem = ESTabBarItem.init(title: "回廊", image: nil, selectedImage: nil)
        v2.tabBarItem = ESTabBarItem.init(title: "轨迹", image: nil, selectedImage: nil)

        viewControllers = [deck, v2]
    }
}
