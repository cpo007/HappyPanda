//
//  gDataModel.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/22.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

class GDataModel: NSObject {
    var galleryId: String = ""
    var galleryToken: String = ""
}


class GMetaModel: BaseModel {
    var gid: Int?
    var token: String?
    var archiver_key: String?
    var title: String?
    var title_jpn: String?
    var category: String?
    var thumb: String?
    var uploader: String?
    var posted: String?
    var filecount: String?
    var filesize: Int?
    var expunged: Bool = false
    var rating: String?
    var torrentcount: Int?
    var uploadtime: String?
    var tags = [String]()
    var sdatas = [SDataModel]()

}

class SDataModel: BaseModel {
    var page_token: String?
    var galleryId: String?
    var pageNumber: Int = 0
}
