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
    var collectionButton: FaveButton!
    
    var gMetaModel: GMetaModel?
    
    
//    var sDataArray = [SDataModel]()
    
    let colors = [
        DotColors(first: UIColorFromRGB(rgbValue: 0x7DC2F4), second: UIColorFromRGB(rgbValue:0xE2264D)),
        DotColors(first: UIColorFromRGB(rgbValue:0xF8CC61), second: UIColorFromRGB(rgbValue:0x9BDFBA)),
        DotColors(first: UIColorFromRGB(rgbValue:0xAF90F4), second: UIColorFromRGB(rgbValue:0x90D1F9)),
        DotColors(first: UIColorFromRGB(rgbValue:0xE9A966), second: UIColorFromRGB(rgbValue:0xF8C852)),
        DotColors(first: UIColorFromRGB(rgbValue:0xF68FA7), second: UIColorFromRGB(rgbValue:0xF6A2B8))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        loadLocalDetail()
        loadComicDetailWeb(page: nil)
    }
    
    
    override func configUI() {
        super.configUI()
        
        setNeedNavigationBar(title: "", needBackButton: true)
        setRightView()
        
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
        
        thumbView.tagLabelDidClick = { [weak self] (tagStr) in
            NotificationCenter.default.post(name: NSNotification.Name.TagDidSearch, object: tagStr)
            self?.navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func setRightView(){
        
        let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        rightView.backgroundColor = UIColor.clear
        
        let collectionButton = FaveButton.init(frame: CGRect.init(x: 0, y: 0, width: 33, height: 33), faveIconNormal: R.image.icon_star())
        collectionButton.selectedColor = RGB(red: 255, green: 172, blue: 51)
//        collectionButton.normalColor = Color.White
        collectionButton.centerY = 22
        collectionButton.delegate = self
        rightView.addSubview(collectionButton)
        self.collectionButton = collectionButton
        
        setNavRightView(rightView: rightView)
    }
    
    private func setupWithGMeta(gMeta: GMetaModel) {
        
        collectionButton.isSelected = gMeta.iscollection
        
        var contentHeight: CGFloat = 0
        let thumbViewHeight = thumbView.initView(data: gMeta) ?? 0
        contentHeight+=thumbViewHeight
        thumbView.height = contentHeight
        
        scrollView.contentSize = CGSize.init(width: 0, height: contentHeight)
    }
    
    //先一步获取本地数据
    private func loadLocalDetail(){
    
    }
    
    private func loadComicDetailWeb(page: Int?){
        
        guard let data = gMetaModel else { return }
        
        var urlString = HPNeetWorking.baseUrl + "/g/\(data.gid)/\(data.token ?? "")/"
        
        if let p = page {
            urlString.append("/?p=\(p)")
        }
        
        showWaitView(color: Color.White)
        HPNeetWorking.shareTools.requestHtml(method: .post, urlString: urlString, completionHandler: { [weak self](html) in
            self?.hideWaitView()
            
            guard let doc = try? HTML(html: html, encoding: .utf8) else { return }
            
            self?.parsingHtmlAndSave(doc: doc)

        }) { (error) in
            
        }
    }
    
    
    private func parsingHtmlAndSave(doc: HTMLDocument) {
        
        guard var gMeta = gMetaModel else {
            ToastUtils.showError(status: "无法获取漫画数据")
            return
        }
        
        let updateTime = Date().timeIntervalSince1970
        
        //如果本地数据库存在值则直接覆写本地数据，若不存在则在写完之后插入本地数据
        
        gMeta.updatetime = Int(updateTime)
        for div in doc.css("div"){
            if div.className == "gm"{
                gMeta = HTMLUtils.getGMetaDetail(gMeta: gMeta, node: div)
            }
            
            if div["id"] == "gdt"{
                let sDataArray = HTMLUtils.getSMetaArray(node: div)
                for i in 0..<sDataArray.count{
                    if gMeta.sDatasL.count <= i {
                        gMeta.sDatasL.append(sDataArray[i])
                    }
                }
            }
        }
        setupWithGMeta(gMeta: gMeta)
        debugPrint(gMeta.sdatas.description)
    }
    
    
    
    deinit {
        print("deinit")
    }

}


extension ComicDetailController: FaveButtonDelegate {
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        
        
    }
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        return colors
    }
    
}
