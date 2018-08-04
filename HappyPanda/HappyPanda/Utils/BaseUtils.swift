//
//  BaseUtils.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit



//默认使用该字符串作为全局的tag切割符号
let tagComponents = "&"

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

//因为直接使用空格作为Tag分割会出现问题，所以使用事先存好的tag列表来对冲漫画的Tag列表
let tagsList = [""]

func getTagsDict(tags: [String]) -> [String:[String]] {
    var dict = [String: [String]]()
    for tag in tags {
        let arr = tag.components(separatedBy: ":")
        if arr.count == 2 {
            
            let tagStrArr = arr[1].components(separatedBy: tagComponents)
            var tagArr = dict[arr[0]] ?? [String]()
            for tagStr in tagStrArr {
                if tagStr.isEmpty { continue }
                tagArr.append(tagStr)
            }
            dict.updateValue(tagArr, forKey: arr[0])
        }
    }
    return dict
}
