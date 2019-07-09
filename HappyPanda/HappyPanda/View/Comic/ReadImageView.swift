//
//  ReadImageView.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/12/18.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import SDWebImage

enum ReadImageViewType {
    case start
    case loading
    case fail
    case success
}

typealias imageRequestSuccess = ((_ image: UIImage, _ sData: SDataModel)->())

//该类需要根据网络类型显示图片状态，并且当状态为显示失败的时候触发点击事件对图片进行重新加载
class ReadImageView: UIImageView {
    
    private var type: ReadImageViewType = ReadImageViewType.start {
        didSet {
            switch type {
            case .start:
                self.image = R.image.icon_start_type()
                break
            case .loading:
                self.image = R.image.icon_loading_type()
                break
            case .fail:
                self.image = R.image.icon_fail_type()
                break
            default:
                break
            }
            
        }
    }
    
    private var successCallBack: imageRequestSuccess?
    private var i: String!
    private var s: SDataModel!
    
    init() {
        super.init(image: nil)
        type = .start
        self.isUserInteractionEnabled = true
        let _ = addOnLongClickListener(target: self, action: #selector(imageDidClick))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func imageDidClick(){
        if type != .fail { return }
        
        self.sd_setImage(with: URL.init(string: i), placeholderImage: R.image.icon_loading_type(), options: SDWebImageOptions.handleCookies) { [weak self](image, error, type, url) in
            guard let weakSelf = self else { return }
            if error != nil {
                weakSelf.type = .fail
                debugPrint(error!)
                return
            }
            weakSelf.successCallBack?(image!,weakSelf.s)
            
            weakSelf.type = .success
            weakSelf.image = image
        }
        
    }
    
    func setImg(imgUrl: String, sData: SDataModel, fileName: String?,successCallBack:imageRequestSuccess?) {
        
        self.i = imgUrl
        self.s = sData
        self.image = nil
        self.successCallBack = successCallBack
                
        if let image = sData.getImageResource(fileName: fileName ?? "") {
            type = .success
            self.image = image
        } else {
            self.sd_setImage(with: URL.init(string: imgUrl), placeholderImage: R.image.icon_loading_type(), options: SDWebImageOptions.handleCookies) { [weak self](image, error, type, url) in
                if error != nil {
                    self?.type = .fail
                    debugPrint(error!)
                    return
                }
                self?.successCallBack?(image!,sData)

                self?.type = .success
                self?.image = image
            }
        }
        
    }

}
