//
//  HTMLUtils.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/7/31.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import Kanna

class HTMLUtils: NSObject {
    
    
    //在保证传进来的节点一定是漫画数据节点时，解析并返回漫画相关数据，以GMetaModel的形式
    static func getGMetaModel(node: XMLElement) -> GMetaModel {
        
        let gMetaModel = GMetaModel()
        
        for n in node.css("td") {
            if n.className == "gl1c glcat" {
                for a in n.css("div"){
                    gMetaModel.category = a.text
                }
            }
            
            if n.className == "gl2c" {
                for itd in n.css("div") {
                    if itd.className == "glthumb" {
                        for img in itd.css("img") {
                            if let imgsrc = img["data-src"], !imgsrc.isEmpty {
                                gMetaModel.thumb = imgsrc
                            } else {
                                gMetaModel.thumb = img["src"]
                            }
                            
                            if let title = img["title"], !title.isEmpty {
                                gMetaModel.title = title
                            }
                            
                        }
                    }
                    if itd.className == "glnew" {
                        gMetaModel.uploadtime = n.text
                    }
                }
            }
            
            if n.className == "gl3c glname" {
                for a in n.css("a"){
                    if let path = a["href"] {
                        if path.hasPrefix(HPNeetWorking.gHead) {
                            var a = path[HPNeetWorking.gHead.endIndex...]
                            if a.hasSuffix("/") { a.removeLast()}
                            let arr = a.components(separatedBy: "/")
                            gMetaModel.gid = Int(arr.first ?? "0") ?? 0
                            gMetaModel.token = arr.last ?? ""
                        }
                    }
                }
            }
            
            if n.className == "gl4c glhide" {
                for a in n.css("a"){
                    gMetaModel.uploader = a.text
                }
            }

        }
        return gMetaModel
    }

    //获取预览图
    static func getGMetaPic(node: XMLElement) -> String? {
        for div in node.css("div") {
            //获取封面图节点
            if div["id"] == "gd1" {
                for subdiv in div.css("div"){
                    let style = subdiv["style"]
                    let arr = (style ?? "").components(separatedBy: " ")
                    for str in arr {
                        if str.hasPrefix("url(") {
                            var thumb = str["url(".endIndex...]
                            if thumb.hasSuffix(")") { thumb.removeLast()}
                            return String(thumb)
                        }
                    }
                }
            }
        }
        return nil
    }

    //通过解析详情页的HTML补完GMetaModel的数据,传入GMetaModel
    static func getGMetaDetail(gMeta: GMetaModel, node: XMLElement) -> GMetaModel {
        for div in node.css("div") {
            
            //获取封面图节点
//            if div["id"] == "gd1" {
//                for subdiv in div.css("div"){
//                    let style = subdiv["style"]
//                    let arr = (style ?? "").components(separatedBy: " ")
//                    for str in arr {
//                        if str.hasPrefix("url(") {
//                            var thumb = str["url(".endIndex...]
//                            if thumb.hasSuffix(")") { thumb.removeLast()}
//                            gMeta.thumb = String(thumb)
//                        }
//                    }
//                }
//            }
            
            //获取标题节点
            if div["id"] == "gd2" {
                for h1 in div.css("hi"){
                    if h1["id"] == "gj" {
                        gMeta.title_jpn = h1.content
                    }
                }
            }
            
            if div["id"] == "gd3" {
                for tr in div.css("tr"){
                    let tds = tr.css("td")
                    
                    if (tds.first?.content?.hasPrefix("Length:") ?? false) && tds.count == 2 {
                        let tdstr = tds[1].content ?? ""
                        let strArr = tdstr.components(separatedBy: " ")
                        print(strArr)
                        gMeta.filecount = strArr.first
                    }
                    
                    if let td = tds.first,td["id"] == "rating_label" {
                        let strArr = td.content?.components(separatedBy: " ")
                        gMeta.rating = strArr?.last
                    }
                }
            }
            
            //获取Tag节点
            if div["id"] == "gd4" {
                gMeta.tagsL.removeAll()
                for tr in div.css("tr") {
                    let tds = tr.css("td")
                    var tagStr = ""
                    if tds.first?.className == "tc" && tds.count == 2 {
                        tagStr.append(tds.first?.content ?? "")
                        let td = tds[1]
                        for a in td.css("a") {
                            tagStr.append(tagComponents)
                            tagStr.append(a.content ?? "")
                        }
                    }
                    gMeta.tagsL.append(tagStr)
                }
            }
        }
        return gMeta
    }
    
    //通过解析详情页的HTML创建SMetaModel数组
    static func getSMetaArray(node: XMLElement) -> [SDataModel] {
        
        var sDatas = [SDataModel]()
        for a in node.css("a") {
            guard let path = a["href"] else { continue }
            
            if path.hasPrefix(HPNeetWorking.sHead) {
                
                var a = path[HPNeetWorking.sHead.endIndex...]
                if a.hasSuffix("/") { a.removeLast()}
                let arr = a.components(separatedBy: "/")
                let model = SDataModel()
                let gidAndPageNum = arr.last ?? ""
                
                let b = gidAndPageNum.components(separatedBy: "-")
                model.galleryId = b.first
                model.pageNumber = Int(b.last ?? "0") ?? 0
                model.page_token = "\(arr.first ?? "")/\(model.galleryId ?? "")-\(model.pageNumber)"
//                model.page_token = arr.first ?? ""
                print(path)
                sDatas.append(model)
            }
        }
        sDatas.sort { $0.pageNumber < $1.pageNumber }
        return sDatas
    }
    
}
