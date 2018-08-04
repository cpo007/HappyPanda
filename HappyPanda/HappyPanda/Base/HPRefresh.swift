//
//  HPRefresh.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/25.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import MJRefresh

extension UIScrollView {
    var uHead: MJRefreshHeader {
        get { return mj_header }
        set { mj_header = newValue }
    }
    
    var uFoot: MJRefreshFooter {
        get { return mj_footer }
        set { mj_footer = newValue }
    }
}

class URefreshHeader: MJRefreshNormalHeader {}

class URefreshAutoHeader: MJRefreshHeader {}

class URefreshFooter: MJRefreshBackNormalFooter {}

class URefreshAutoFooter: MJRefreshAutoNormalFooter {}
