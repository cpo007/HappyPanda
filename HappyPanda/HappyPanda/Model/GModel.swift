//
//  gDataModel.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/22.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import WCDBSwift

class GMETAMODEL: TableCodable {
    //Your own properties
    let variable1: Int = 0
    var variable2: String? // Optional if it would be nil in some WCDB selection
    var variable3: Double? // Optional if it would be nil in some WCDB selection
    let unbound: Date? = nil
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = GMETAMODEL
        
        //List the properties which should be bound to table
        case variable1 = "custom_name"
        case variable2
        case variable3
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        //static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
        //    return [
        //        .variable: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true),
        //        .variable2: ColumnConstraintBinding(isUnique: true)
        //    ]
        //}
        
      
    }
    
    //Properties below are needed only the primary key is auto-incremental
    //var isAutoIncrement: Bool = false
    //var lastInsertedRowID: Int64 = 0
}

class GDataModel: NSObject {
    var galleryId: String = ""
    var galleryToken: String = ""
}


class GMetaModel {
    var gid: Int = 0
    var token: String?
    var archiver_key: String?
    var title: String?
    var title_jpn: String?
    var category: String?
    var thumb: String?
    var uploader: String?
    var posted: String?
    var filecount: String?
    var filesize: Int = 0
    var expunged: Bool = false
    var rating: String?
    var torrentcount: Int = 0
    var uploadtime: String?
    var iscollection: Bool = false

    //本地保存时更新时间序列
    var updatetime = 0
    var collectiontime = 0
    var tagsL = [String]()
    var sDatasL = [SDataModel]()

    lazy var tags: [String] = {
        var t = [String]()
        for tag in tagsL {
            t.append(tag)
        }
        return t
    }()
    
    lazy var sdatas: [SDataModel] = {
        var s = [SDataModel]()
        for data in sDatasL {
            s.append(data)
        }
        return s
    }()
    
}

class SDataModel {
    var page_token: String?
    var galleryId: String?
    var pageNumber: Int = 0
    var picUrl: String?
    
    
    func getImageResource(fileName: String) -> UIImage? {
        return ImageUtils.getImage(fileName: fileName, imageName: "\(pageNumber).jpg")
    }
}

class SearchModel {
    var searchStr: String?
    var updatetime = 0

}
