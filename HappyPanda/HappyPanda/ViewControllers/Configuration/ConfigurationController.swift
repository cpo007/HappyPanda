//
//  ConfigurationController.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import SnapKit

class ConfigurationController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    private var pandaData: Data?
    
    private var viewArray = [UIView]()
    
    var cancelButton: UIButton!
    var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        nextButton = UIButton.init()
        nextButton.backgroundColor = Color.ace
        nextButton.setTitle("下一步", for: UIControlState.normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextButton.tag = 101
        nextButton.addTarget(self, action: #selector(buttonDidClick(sender:)), for: UIControlEvents.touchUpInside)
        
        cancelButton = UIButton.init()
        cancelButton.backgroundColor = Color.ace
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelButton.tag = 102
        cancelButton.addTarget(self, action: #selector(buttonDidClick(sender:)), for: UIControlEvents.touchUpInside)

      
        
        for i in 0..<4{
            setView(num: i)
        }
        
        scrollView.contentSize = CGSize.init(width: Int(kScreenWidth) * viewArray.count, height: 0)
        scrollView.backgroundColor = Color.backgroundColor
        
        for v in viewArray {
            scrollView.addSubview(v)
        }
        
        view.addSubview(cancelButton)
        view.addSubview(nextButton)
        
        cancelButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view).offset(-80)
            make.bottom.equalTo(view).offset(-100)
            make.size.equalTo(CGSize.init(width: 120, height: 49))
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view).offset(80)
            make.bottom.equalTo(view).offset(-100)
            make.size.equalTo(CGSize.init(width: 120, height: 49))
        }
        
        
    }
    
    func getPandaImage(data: Data) {
        pandaData = data
    }

    func setView(num: Int) {
        
        switch num {
        case 0:
            let view = PandaView.init(frame: getFrame(num: num))
            if let d = pandaData {
                view.getPandaData(data: d)
            }
            viewArray.append(view)
            break
        case 1:
            let view = CookiesRemoveView.init(frame: getFrame(num: num))
            viewArray.append(view)
            break
        case 2:
            let view = ShowWebView.init(frame: getFrame(num: num))
            view.tag = 201
            viewArray.append(view)
            break
        case 3:
            let view = ShowWebView.init(frame: getFrame(num: num))
            view.tag = 202
            viewArray.append(view)
            break
        default:
            break
        }
    }
    
    func getFrame(num: Int) -> CGRect {
        return CGRect.init(x: kScreenWidth * CGFloat(num), y: 0, width: kScreenWidth, height: kScreenHeight)
    }
    
    
    @objc private func buttonDidClick(sender: UIButton) {
        
        let index = scrollView.contentOffset.x / kScreenWidth + 1
        print(index)
        
        switch sender.tag {
        case 101 :
            scrollView.setContentOffset(CGPoint.init(x: scrollView.contentOffset.x + kScreenWidth, y: 0), animated: true)
            
            
            if index == 2 {
                let storage = HTTPCookieStorage.shared
                if let cookies = storage.cookies {
                    for cookie in cookies {
                        storage.deleteCookie(cookie)
                    }
                }
                
                let webViews = viewArray.filter { (v) in v is ShowWebView }
                
                for v in webViews {
                    if v.tag == 201 {
                        (v as! ShowWebView).loadBBSWeb()
                    }
                }
                
            }
            if index == 3 {
                let webViews = viewArray.filter { (v) in v is ShowWebView }
                for v in webViews {
                    if v.tag == 202 {
                        (v as! ShowWebView).loadEXWeb()
                    }
                }
                
                nextButton.setTitle("是的，配置成功", for: UIControlState.normal)
                cancelButton.setTitle("我恨那只熊猫，再来一次", for: UIControlState.normal)
            }
            
            if index == 4 {
                NotificationCenter.default.post(name: NSNotification.Name.ConfigurationDone, object: nil)
                dismiss(animated: true, completion: nil)
            }
            
            break
        case 102 :
            
            if index == 4 {
                NotificationCenter.default.post(name: NSNotification.Name.ConfigurationDone, object: nil)
            }
            dismiss(animated: true, completion: nil)
            
            break
        default :
            break
        }
    }
    
    
}


extension ConfigurationController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        nextButton.isEnabled = true
        cancelButton.isEnabled = true
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        nextButton.isEnabled = false
        cancelButton.isEnabled = false
    }
    
}
