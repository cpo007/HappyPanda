//
//  SettingUtils.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/8/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
//import RealmSwift

public class SettingUtils {
    
    private init() {}
    public static let share = SettingUtils.init()
    
    //获取本地用户偏好设置
    func getUserPreferences() -> UserPreference? {
        return nil
    }
    
    func setUserPreferences(index: IndexPath,value: String) {
    }
    
    
    private func initNewUserPreference() -> UserPreference{
        let userPreference = UserPreference()
//        userPreference.userPreferenceId = SettingUtils.userPreferenceId
//
//        //下载偏好设置
//        let downloadPreference = PreferenceListModel()
//        downloadPreference.listPreferenceId = SettingUtils.downloadPreferenceId
//        downloadPreference.listPreferenceName = "下载管理"
//
//        let isDownloadWhenCollecton = PreferenceModel()
//        isDownloadWhenCollecton.preferenceId = SettingUtils.isDownloadWhenCollectionId
//        isDownloadWhenCollecton.preferenceName = "收藏的漫画阅读时自动进行本地保存"
//        isDownloadWhenCollecton.style = 1
//        isDownloadWhenCollecton.desc = "0"
//
//        downloadPreference.preferences.append(isDownloadWhenCollecton)
//
//        userPreference.listPreferences.append(downloadPreference)
//
        return userPreference
    }
    

}


// MARK: 存放用户偏好ID
extension SettingUtils {
    
    public static let userPreferenceId = "UserPreference"
    public static let downloadPreferenceId = "DownloadPreference"
    public static let isDownloadWhenCollectionId = "IsDownloadWhenCollection"


}
