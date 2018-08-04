//
//  LoginEhentaiBBSView.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

class ShowWebView: UIView {
    
    private var webView: UIWebView?
    private var instructionsLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        webView = UIWebView.init()
        
        instructionsLabel = UILabel()
        instructionsLabel!.textAlignment = .center
        instructionsLabel!.textColor = Color.ace
        instructionsLabel!.numberOfLines = 0
        
        addSubview(webView!)
        addSubview(instructionsLabel!)
        
        webView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 60, left: 10, bottom: 230, right: 10))
        })
        
        instructionsLabel?.snp.makeConstraints { (make) in
            make.top.equalTo(webView!.snp.bottom).offset(24)
            make.centerX.equalTo(webView!)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
        }
        
        
    }

    func loadBBSWeb(){
        
        if let url = URL.init(string: HPNeetWorking.forumsUrl) {
            DispatchQueue.main.async { [weak self] in
                self?.webView?.loadRequest(URLRequest.init(url: url))
            }
        }
        instructionsLabel?.text = "成功登录账号后点击下一步继续配置"
        
    }
    
    func loadEXWeb(){
        if let url = URL.init(string: HPNeetWorking.baseUrl) {
            DispatchQueue.main.async { [weak self] in
                self?.webView?.loadRequest(URLRequest.init(url: url))
            }
        }
        instructionsLabel?.text = "请问是否能正确地看到EXHentai页面？"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
