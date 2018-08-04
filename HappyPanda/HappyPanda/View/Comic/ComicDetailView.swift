//
//  ComicDetailView.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/23.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage
class ComicDetailView: UIView {
    
    
    var thumb: UIImageView!
    var buttonView: UIView!
    var tagsView: UIView!
    var title: UILabel!

    private var placeholder: UIImage?

    var buttonDidClickBlock:((_ sender: UIButton)->())?
    
    var data: GMetaModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        placeholder = createImage(color: Color.darkCyan)
        thumb = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 120, height: 145))
        thumb.contentMode = .scaleAspectFill
        thumb.cornerRadius = 5
        thumb.image = placeholder
        
        title = UILabel()
        
        buttonView = UIView.init(frame: CGRect.init(x: 10, y: thumb.frame.maxY + 10, width: kScreenWidth - 20, height: 46))
        
        tagsView = UIView.init(frame: CGRect.init(x: 0, y: buttonView.frame.maxY + 10, width: kScreenWidth - 20, height: 0))
        tagsView.centerX = self.centerX
        
        self.backgroundColor = Color.ace
        tagsView.backgroundColor = UIColor.clear
        
        addSubview(thumb)
        addSubview(buttonView)
        addSubview(tagsView)
        
        initButtonSubView()
    }
    

    private func initButtonSubView(){
        
        let readButton = UIButton.init(frame: CGRect.init(x: 0, y: 10, width: 100, height: 30))
        readButton.setTitle("立即阅读", for: UIControlState.normal)
        readButton.setTitleColor(Color.White, for: UIControlState.normal)
        readButton.cornerRadius = 15
        readButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        readButton.borderWidth = 0.67
        readButton.boardColor = Color.White
        
        readButton.centerX = self.centerX
        readButton.addTarget(self, action: #selector(buttonDidClick(sender:)), for: UIControlEvents.touchUpInside)
        
        buttonView.addSubview(readButton)
        
        
    }
    
    func initView(data: GMetaModel) -> CGFloat? {
        
        thumb.sd_setImage(with: URL.init(string: data.thumb ?? ""), placeholderImage: placeholder, options: SDWebImageOptions.handleCookies) { [weak self](image, error, type, url) in
            if error != nil {
                debugPrint(error)
                return
            }
            self?.thumb.image = image
        }

        let tagDict = getTagsDict(tags: data.tags)
        
        let space: CGFloat = 0
        let tagViewWidth = tagsView.frame.width - 80
        var allTagViewHeight: CGFloat = 0
        var viewIndex = 0
        
        for (k,v) in tagDict {
            
            let tagView = UIView()
            let tagsNameLabel = UILabel()
            tagsNameLabel.text = "\(k):"
            tagsNameLabel.numberOfLines = 1
            tagsNameLabel.font = UIFont.systemFont(ofSize: 12)
            tagsNameLabel.textColor = Color.White
            tagsNameLabel.textAlignment = .right
            
            tagsView.addSubview(tagView)
            tagsView.addSubview(tagsNameLabel)
            
            var allTagLabelWidth: CGFloat = 0
            let labelOffsetL: CGFloat = 8
            let labelOffsetT: CGFloat = 8
            let labelHeight: CGFloat = 20
            let labelMargin: CGFloat = 8
            var index = 0
            var line = 0
            var row = 0
            
            for tagStr in v {
                
                let textWidth = tagStr.widthWithConstrainedHeight(20, font: UIFont.systemFont(ofSize: 14))
                
                if Int((allTagLabelWidth + textWidth + labelMargin * 2 + labelOffsetL * 2) / tagViewWidth) >= 1 {
                    row+=1
                    allTagLabelWidth = 0
                    line = 0
                }
                
                let tagLabel = UILabel()
                tagLabel.font = UIFont.systemFont(ofSize: 14)
                tagLabel.borderWidth = 1
                tagLabel.cornerRadius = 3
                tagLabel.boardColor = Color.White
                tagLabel.text = tagStr
                tagLabel.textAlignment = .center
                tagLabel.textColor = Color.White
                let _ = tagLabel.addOnClickListener(target: self, action: #selector(tagDidClick(tap:)))
                
                tagView.addSubview(tagLabel)
                
                allTagLabelWidth+=labelOffsetL
                
                tagLabel.frame = CGRect.init(x: allTagLabelWidth, y: labelOffsetT * CGFloat(row + 1) + CGFloat(row) * labelHeight, width: textWidth + labelMargin * 2, height: labelHeight)
                allTagLabelWidth+=(textWidth + labelMargin * 2)
                line+=1
                index+=1
            }
            
            let tagViewHeight = CGFloat(row + 2) * labelOffsetT + CGFloat(row + 1) * labelHeight
            allTagViewHeight+=space
            
            tagView.frame = CGRect.init(x: 70, y: allTagViewHeight, width: tagsView.width - 80, height: tagViewHeight)
            tagsNameLabel.frame = CGRect.init(x: space, y: tagView.y + 7 , width: (tagsView.width - tagView.width) - 8 * 2, height: 20)
            
            allTagViewHeight+=tagViewHeight
            viewIndex+=1
        }
        
        tagsView.height = allTagViewHeight + space
        return tagsView.frame.maxY + space
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc private func tagDidClick(tap: UIGestureRecognizer){
        guard let label = tap.view as? UILabel else { return }
        
        debugPrint(label.text ?? "")
        
    }
    
    @objc private func buttonDidClick(sender: UIButton) {
        
        buttonDidClickBlock?(sender)
    }
}
