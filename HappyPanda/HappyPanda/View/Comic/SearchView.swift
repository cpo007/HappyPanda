//
//  SearchView.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/28.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

class SearchView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.White
        configUI()
    }

    
    private func configUI(){
        
        let categoryArr = ["DOUJINSHI","MANGA","ARTIST CG","GAME CG","WESTERN","NON-H","IMAGESET","COSPLAY","ASIAN PORN","MISC"]
        
        let spaceW: CGFloat = 8
        let spaceH: CGFloat = 15
        let num = 5
        let labelW = (kScreenWidth - spaceW * CGFloat(num + 1)) / CGFloat(num)
        let labelH: CGFloat = 25
        
        for i in 0..<categoryArr.count{
            
            let a = i % num
            let b = i / num
            
            let button = UIButton.init(frame: CGRect.init(x: CGFloat(a + 1) * spaceW + CGFloat(a) * labelW, y: CGFloat(b + 1) * spaceH + CGFloat(b) * labelH, width: labelW, height: labelH))
            
            setButtonStyle(button: button, num: i)
            button.setTitle(categoryArr[i], for: UIControlState.normal)
            
            button.tag = i
            button.addTarget(self, action: #selector(categoryDidClick(sender:)), for: UIControlEvents.touchUpInside)
            
            addSubview(button)
            
        }
        
    }
    
    private func setButtonStyle(button: UIButton, num: Int){
        
        button.cornerRadius = 3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        button.setBackgroundImage(createImage(color: UIColor.lightGray), for: UIControlState.selected)
        switch num {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        case 4:
            break
        case 5:
            break
        case 6:
            break
        case 7:
            break
        case 8:
            break
        case 9:
            break
        default:
            break
        }
        
    }

    
    @objc private func categoryDidClick(sender: UIButton) {
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
