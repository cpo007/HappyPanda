//
//  CookiesRemoveView.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

class CookiesRemoveView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let cookieImageView = UIImageView.init(image: R.image.icon_cookies())
        let instructionsLabel = UILabel()
        instructionsLabel.textAlignment = .center
        instructionsLabel.text = "清除此App产生的Cookies，这项操作不会影响到其他App，点击下一步开始清除."
        instructionsLabel.textColor = Color.ace
        instructionsLabel.numberOfLines = 0
        
        addSubview(cookieImageView)
        addSubview(instructionsLabel)
        
        cookieImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(100)
        }
        
        instructionsLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(cookieImageView)
            make.top.equalTo(cookieImageView.snp.bottom).offset(24)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
