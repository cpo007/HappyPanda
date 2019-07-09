//
//  ReadCell.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/25.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage

class ReadCell: UICollectionViewCell {
    
    private var placeholder: UIImage?
    
    var imageRequestSuccess: ((_ image: UIImage, _ sData: SDataModel)->())?

    lazy var imageView: ReadImageView = {
        let iw = ReadImageView()
        iw.contentMode = .scaleAspectFit
        iw.clipsToBounds = true
        return iw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeholder = createImage(color: Color.purple)

        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setImg(imgUrl: String, sData: SDataModel, fileName: String?,successCallBack:imageRequestSuccess?) {
        
        imageView.setImg(imgUrl: imgUrl, sData: sData, fileName: fileName, successCallBack: successCallBack)
    }
    
}
