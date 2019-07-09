//
//  SettingModel.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/8/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

class UserPreference: NSObject {
    
    var userPreferenceId: String?
    let listPreferences = [PreferenceListModel]()
    
}

class PreferenceListModel {
    
    var listPreferenceName: String?
    var listPreferenceId: String?
    let preferences = [PreferenceModel]()

}

class PreferenceModel {
    
    @objc dynamic var preferenceName: String?
    @objc dynamic var preferenceId: String?
    @objc dynamic var style: Int = 0  //0:无效果 1:switch
    @objc dynamic var desc: String? //存放该项的偏好设置 若该项为Bool值则 desc为 0：false 1：true
    let listPreferences = [PreferenceListModel]()
}


