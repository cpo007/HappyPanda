//
//  ReadSettingBar.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/26.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

class ReadSettingBar: UIView {
    
    lazy var backgroundImage: UIImageView = {
        let img = UIImageView.init(image: R.image.icon_readbar_background())
        return img
    }()

    lazy var backButton: UIButton = {
        let bn = UIButton(type: .custom)
        bn.setTitleColor(UIColor.white, for: UIControlState.normal)
        bn.cornerRadius = 5
        bn.borderWidth = 2
        bn.boardColor = Color.purple
        bn.setTitle("回到列表", for: UIControlState.normal)
        bn.setBackgroundImage(R.image.icon_backbtn_background(), for: UIControlState.normal)
        return bn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        addSubview(backgroundImage)
        
        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(backButton)
        
        backButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 200, height: 60))
            make.top.equalToSuperview().offset(140)
        }
        
        
        
    }

}
