//
//  ComicDetailCell.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/22.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage


class ComicDetailCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var uploadTime: UILabel!
    
    private var placeholder: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        placeholder = createImage(color: Color.purple)
        backgroundColor = UIColor.clear
    }
    
    func loadData(gMetaModel: GMetaModel) {
        
        thumb.sd_setImage(with: URL.init(string: gMetaModel.thumb ?? ""), placeholderImage: placeholder, options: SDWebImageOptions.handleCookies) { [weak self](image, error, type, url) in
            if error != nil {
                debugPrint(error!)
                return
            }
            self?.thumb.image = image
        }
        
        title.text = gMetaModel.title
        
        artist.text = "artist: " + (gMetaModel.uploader ?? "")
        tags.text = "category: " + (gMetaModel.category ?? "")
        
        if gMetaModel.uploadtime != nil {
            uploadTime.text = "upload time: " + gMetaModel.uploadtime! 
        } else {
            let posted = Int(gMetaModel.posted ?? "0") ?? 0
            let date = Date.init(timeIntervalSince1970: TimeInterval(posted))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            uploadTime.text = "upload time: " +  formatter.string(from: date)
        }
    }

}
