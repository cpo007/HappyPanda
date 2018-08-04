//
//  ComicDetailController.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/23.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import Kanna

class ComicDetailController: BaseViewController {

    var scrollView: UIScrollView!
    var thumbView: ComicDetailView!
    
    var gMetaModel: GMetaModel?
    
//    var sDataArray = [SDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        loadComicDetailWeb(page: nil)
    }
    
    
    override func configUI() {
        super.configUI()
        
        setNeedNavigationBar(title: "", needBackButton: true)
        
        let offY: CGFloat = DeviceUtils.isIphoneX() ? 84 : 64
        
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: offY, width: kScreenWidth, height: kScreenHeight - offY))
        view.addSubview(scrollView)
        scrollView.backgroundColor = Color.ace
        
        thumbView = ComicDetailView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        scrollView.addSubview(thumbView)
        
        thumbView.buttonDidClickBlock = {[weak self] (sender) in
            guard let weakSelf = self else { return }
            
            if weakSelf.gMetaModel?.sdatas.count == 0 {
                ToastUtils.showError(status: "尚未加载成功或加载失败")
                return
            }
            
            let vc = ReadViewController()
            vc.gMetaModel = weakSelf.gMetaModel
            
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    private func setupWithGMeta(gMeta: GMetaModel) {
        var contentHeight: CGFloat = 0
        
        let thumbViewHeight = thumbView.initView(data: gMeta) ?? 0
        contentHeight+=thumbViewHeight
        thumbView.height = contentHeight
        
        scrollView.contentSize = CGSize.init(width: 0, height: contentHeight)
    }
    
    private func loadComicDetailWeb(page: Int?){
        
        guard var data = gMetaModel else { return }
        
        var urlString = HPNeetWorking.baseUrl + "/g/\(data.gid ?? 0)/\(data.token ?? "")/"
        
        if let p = page {
            urlString.append("/?p=\(p)")
        }
        
        showWaitView(color: Color.White)
        HPNeetWorking.shareTools.requestHtml(method: .post, urlString: urlString, completionHandler: { [weak self](html) in
            self?.hideWaitView()
            
            if let doc = try? HTML(html: html, encoding: .utf8) {
                
                for div in doc.css("div"){
                    if div.className == "gm"{
                       data = HTMLUtils.getGMetaDetail(gMeta: data, node: div)
                    }
                    
                    if div["id"] == "gdt"{
                        let sDataArray = HTMLUtils.getSMetaArray(node: div)
                        for i in 0..<sDataArray.count{
                            if data.sdatas.count <= i {
                                data.sdatas.append(sDataArray[i])
                            }
                        }
                    }
                }
                self?.setupWithGMeta(gMeta: data)
//                self?.gMetaModel = data
            }
        }) { (error) in
            
        }
    }
    
    
    deinit {
        print("deinit")
    }

}
