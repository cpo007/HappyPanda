//
//  PandaView.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import SnapKit

class PandaView: UIView {

    private var pandaImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        pandaImageView = UIImageView()
        let instructionsLabel = UILabel()
        instructionsLabel.textAlignment = .center
        instructionsLabel.text = "当前无法获取EX绅士数据，请根据说明进行配置"
        instructionsLabel.textColor = UIColor.black
        instructionsLabel.numberOfLines = 0
        
        addSubview(pandaImageView!)
        addSubview(instructionsLabel)
        
        pandaImageView!.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(100)
            make.size.equalTo(CGSize.init(width: 220, height: 220))
        }
        
        instructionsLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(pandaImageView!)
            make.top.equalTo(pandaImageView!.snp.bottom).offset(24)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
        }
        
    }
    
    func getPandaData(data: Data){
        pandaImageView?.image = UIImage.init(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
