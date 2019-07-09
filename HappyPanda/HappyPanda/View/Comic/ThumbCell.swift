//
//  ThumbCell.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/12/17.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import SDWebImage

class ThumbCell: UICollectionViewCell {
    
    private var placeholder: UIImage?
    
    private var thumb: UIImageView!
    private var pageNumText: UITextView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeholder = createImage(color: Color.purple)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configUI() {
        
        thumb = UIImageView.init()
        thumb.contentMode = .scaleAspectFit
        
        pageNumText = UITextView.init()
        pageNumText.textAlignment = .center
        pageNumText.textColor = UIColor.white
        pageNumText.backgroundColor = UIColor.clear
        pageNumText.font = UIFont.systemFont(ofSize: 20)
        
        contentView.addSubview(thumb)
        contentView.addSubview(pageNumText)
        
        thumb.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(ReadSettingBar.thumbHeight * 4 / 5)
        }
        
        pageNumText.snp.makeConstraints { (make) in
            make.top.equalTo(thumb.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    
    func setImg(imgUrl: String,pageNumber: Int) {
        thumb.image = nil
        pageNumText.text = "\(pageNumber + 1)"
        thumb.sd_setImage(with: URL.init(string: imgUrl), placeholderImage: placeholder, options: SDWebImageOptions.handleCookies) { [weak self](image, error, type, url) in
            if error != nil {
                debugPrint(error!)
                return
            }
            self?.thumb.image = image
        }
        
    }
}
