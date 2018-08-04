//
//  ReadCell.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/25.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import Kingfisher

class ReadCell: UICollectionViewCell {
    
    private var placeholder: UIImage?

    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.backgroundColor = RandomColor()
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
    
    var imgUrl: String? {
        didSet {
            guard let imgUrl = imgUrl else { return }
            imageView.image = nil
            imageView.kf.setImage(with: URL.init(string: imgUrl), placeholder: placeholder)
        }
    }
}
