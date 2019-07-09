//
//  HPNetWork.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/19.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import Alamofire

public class HPNeetWorking {
    
    static let baseUrl = "https://exhentai.org"
    static let baseUrlAPI = "https://api.e-hentai.org/api.php"
    static let forumsUrl = "https://forums.e-hentai.org"
    static let gHead = "https://exhentai.org/g/"
    static let sHead = "https://exhentai.org/s/"

    static let shareTools:HPNeetWorking = HPNeetWorking()
    //typealias EHNetworkwingCallBack = (_ response: Any?)->()
    
    typealias APIHandler = ((Data)->())
    typealias APIErrorHandler = ((Error?)->())
    
    
    
    func requestHtml(method: HTTPMethod, urlString: String, parameters: [String:Any]? = nil ,completionHandler: @escaping APIHandler, errorHandler: @escaping APIErrorHandler) {
        
        let _ = Alamofire.SessionManager.default
        
        Alamofire.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: nil).response { (response) in
            if !self.checkData(data: response) {
                errorHandler(response.error)
                return
            }
            completionHandler(response.data!)
        }
    }
    
    //网络请求基方法,带入参
    func request(method: HTTPMethod, urlString: String, params: [String : Any]?,completionHandler: @escaping APIHandler, errorHandler: @escaping APIErrorHandler){
        
        Alamofire.request(urlString, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).response { (response) in
            if !self.checkData(data: response) {
                errorHandler(response.error)
                return
            }
            completionHandler(response.data!)
        }
    }
    
    private func checkData(data: DefaultDataResponse) -> Bool {
        if data.error != nil {
            debugPrint("错了错了！数据接口有误！\(data.error!)")
            return false
        }
        return true
    }
}

//扩展存放各种衍生出来的页面网络请求方法
extension HPNeetWorking{
    
    //通过gDataModel请求漫画简介数据
    func requestComicDetail(gDataArray: [GDataModel],completionHandler: @escaping APIHandler, errorHandler: @escaping APIErrorHandler) {
        
        var arrs = [Any]()
        for gData in gDataArray {
            var arr = [Any]()
            arr.append(gData.galleryId)
            arr.append(gData.galleryToken)
            arrs.append(arr)
        }
        
        let params = ["method":"gdata",
                      "gidlist":arrs,
                      "namespace":gDataArray.count] as [String : Any]
        
        request(method: .post, urlString: HPNeetWorking.baseUrlAPI, params: params, completionHandler: completionHandler, errorHandler: errorHandler)
        
    }

}
