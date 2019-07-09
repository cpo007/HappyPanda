//
//  SearchView.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/28.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

let categoryArr = ["DOUJINSHI","MANGA","ARTIST CG","GAME CG","WESTERN","NON-H","IMAGESET","COSPLAY","ASIAN PORN","MISC"]

class TagsView: UIView {
    
    var buttonView: UIView!
    
    var buttonArr = [UIButton]()
    
    var tagsTypes: [String: String] {
        get {
            let tuples = buttonArr.map { (button) -> (String,String) in
                let tag = "f_" + categoryArr[button.tag].lowercased().replacingOccurrences(of: " ", with: "")
                return (tag,button.isSelected ? "0" : "1")
            }
            var dict = [String:String]()
            
            for (t1,t2) in tuples {
                dict[t1] = t2
            }
            return dict
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    private func configUI(){
        
        let spaceW: CGFloat = 8
        let spaceH: CGFloat = 15
        let num = 3
        let labelW = (width - spaceW * CGFloat(num + 1)) / CGFloat(num)
        let labelH: CGFloat = 25
        
        var maxH:CGFloat = 0
        
        buttonView = UIView()
        addSubview(buttonView)
        
        for i in 0..<categoryArr.count{
            
            let a = i % num
            let b = i / num
            
            let button = UIButton()
            if i == categoryArr.count - 1 {
                button.frame =  CGRect.init(x: CGFloat(a + 1) * spaceW + CGFloat(a) * labelW, y: CGFloat(b + 1) * spaceH + CGFloat(b) * labelH, width: labelW, height: labelH)
                button.centerX = width / 2
                maxH = button.frame.maxY
            } else {
                button.frame =  CGRect.init(x: CGFloat(a + 1) * spaceW + CGFloat(a) * labelW, y: CGFloat(b + 1) * spaceH + CGFloat(b) * labelH, width: labelW, height: labelH)
            }
            
            setButtonStyle(button: button, num: i)
            button.setTitle(categoryArr[i], for: UIControlState.normal)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.tag = i
            button.addTarget(self, action: #selector(categoryDidClick(sender:)), for: UIControlEvents.touchUpInside)
            buttonArr.append(button)
            addSubview(button)
        }
        
        buttonView.frame = CGRect.init(x: 0, y: 0, width: width, height: maxH + 15)
        
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(buttonView)
        }
        
    }
    
    private func setButtonStyle(button: UIButton, num: Int){
        
        button.cornerRadius = 3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        button.setBackgroundImage(createImage(color: UIColor.lightGray), for: UIControlState.selected)
        switch num {
        case 0:
            button.setBackgroundImage(createImage(color: UIColorFromRGB(rgbValue: 0xF2747F)), for: UIControlState.normal)
            break
        case 1:
            button.setBackgroundImage(createImage(color: UIColorFromRGB(rgbValue: 0xF4A060)), for: UIControlState.normal)
            break
        case 2:
            button.setBackgroundImage(createImage(color: UIColorFromRGB(rgbValue: 0xFBBC2B)), for: UIControlState.normal)
            break
        case 3:
            button.setBackgroundImage(createImage(color: UIColorFromRGB(rgbValue: 0x7DCDCA)), for: UIControlState.normal)
            break
        case 4:
            button.setBackgroundImage(createImage(color: UIColorFromRGB(rgbValue: 0x23DAD3)), for: UIControlState.normal)
            break
        case 5:
            button.setBackgroundImage(createImage(color: UIColorFromRGB(rgbValue: 0x85D8FF)), for: UIControlState.normal)
            break
        case 6:
            button.setBackgroundImage(createImage(color: UIColorFromRGB(rgbValue: 0x38BEFE)), for: UIControlState.normal)
            break
        case 7:
            button.setBackgroundImage(createImage(color: UIColorFromRGB(rgbValue: 0xAE8BBA)), for: UIControlState.normal)
            break
        case 8:
            button.setBackgroundImage(createImage(color: UIColorFromRGB(rgbValue: 0xFFCBCF)), for: UIControlState.normal)
            break
        case 9:
            button.setBackgroundImage(createImage(color: UIColorFromRGB(rgbValue: 0xFEF2E3)), for: UIControlState.normal)
            break
        default:
            break
        }
        
    }

    
    @objc private func categoryDidClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
