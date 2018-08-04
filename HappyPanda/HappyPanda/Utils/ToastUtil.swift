//
//  ToastUtil.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/26.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import Foundation
import SVProgressHUD

public struct ToastUtils {
    
    public static func setSV(){
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
    }
    
    public static func showSuccess(status: String) {
        SVProgressHUD.showSuccess(withStatus: status)
    }
    
    public static func isVisiable() -> Bool{
        return SVProgressHUD.isVisible()
    }
    
    public static func show(status: String) {
        SVProgressHUD.show(withStatus: status)
    }
    
    public static func showInfo(status: String) {
        SVProgressHUD.showInfo(withStatus: status)
    }
    
    public static func showError(status: String){
        SVProgressHUD.showError(withStatus: status)
    }
    public static func dismiss(){
        SVProgressHUD.dismiss()
    }
    
}
