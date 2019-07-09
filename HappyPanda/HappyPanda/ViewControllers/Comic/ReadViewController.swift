//
//  ReadViewController.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/25.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import Kanna

class ReadViewController: BaseViewController {
    
    var edgeInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }

    var gMetaModel: GMetaModel!
    var imgArray = [String]()
    var thumbDict = [Int: UIImage]()
    var page = 0
    var canDownLoad = false
    var isLoading = false //控制RightTapView不要多次加载
    
    var selectedRow = 0 //这个属性控制当SettingBar显示时应该滚动到哪一个Item
    
    
    private var isBarHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                self.settingBar.alpha = self.isBarHidden ? 0 : 1
            }) { (isEnd) in
                if !self.isBarHidden {
                    self.settingBar.resetView(selectedRow: self.selectedRow)
                }
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        loadComic()
        
        let preference = SettingUtils.share.getUserPreferences()?.listPreferences.filter({
            return $0.listPreferenceId == SettingUtils.downloadPreferenceId
        }).first?.preferences.filter({
            return $0.preferenceId == SettingUtils.isDownloadWhenCollectionId
        }).first?.desc
        
        canDownLoad = preference == "1"
        
    }
    
    override func configUI() {
        super.configUI()
        view.backgroundColor = UIColor.white
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints { $0.edges.equalTo(self.view.snp.edges) }
        
        backScrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.snp.edges)
        }
        
        let rightTapView = UIView.init(frame: CGRect.zero)
        let _ = rightTapView.addOnClickListener(target: self, action: #selector(rightTapAction))
        view.addSubview(rightTapView)
        
        rightTapView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(view)
            make.width.equalTo(100)
        }
        
        view.addSubview(settingBar)
        settingBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    private func loadComic(){
        if imgArray.count < gMetaModel.sdatas.count {
            let sData = gMetaModel.sdatas[imgArray.count]
//            let url = HPNeetWorking.sHead + "\(sData.page_token ?? "")/\(sData.galleryId ?? "")-\(sData.pageNumber)"
            let url = HPNeetWorking.sHead + (sData.page_token ?? "")
            
            HPNeetWorking.shareTools.requestHtml(method: .post, urlString: url, completionHandler: { [weak self](html) in
                self?.hideWaitView()
                if let doc = try? HTML(html: html, encoding: .utf8) {
                   self?.parsingHtml(doc: doc,pageNum: sData.pageNumber)
                }
                
            }) { [weak self] (error) in
                self?.hideWaitView()
            }
            
        } else {
            page+=1
            loadComicDetailWeb(page: page)
        }
    }
    
    
    private func parsingHtml(doc: HTMLDocument,pageNum: Int){
        for link in doc.css("img") {
            if let path = link["src"] {
                if !path.hasPrefix("https://"){
                    print(path)
                    imgArray.append(path)
                    settingBar.thumbArray = imgArray
                    collectionView.reloadData()
                    collectionView.scrollToItem(at: IndexPath.init(row: imgArray.count - 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
                    selectedRow = imgArray.count - 1
                }
            }
        }
    }
    
    private func loadComicDetailWeb(page: Int?){
        
        guard let data = gMetaModel else { return }
        if gMetaModel.sdatas.count >= Int(data.filecount ?? "0") ?? 0 {
            hideWaitView()
            return }
        
        var urlString = HPNeetWorking.gHead + "\(data.gid)/\(data.token ?? "")/"
        
        if let p = page {
            urlString.append("/?p=\(p)")
        }
        print(urlString)
        
        HPNeetWorking.shareTools.requestHtml(method: .post, urlString: urlString, completionHandler: { [weak self](html) in
            if let doc = try? HTML(html: html, encoding: .utf8) {
                
                for div in doc.css("div"){
                    if div["id"] == "gdt"{
                        self?.loadComic()
                    }
                }
            }
        }) { [weak self] (error) in
            self?.hideWaitView()
        }
    }
    
    lazy var backScrollView: UIScrollView = {
        let sw = UIScrollView()
        sw.delegate = self
        sw.minimumZoomScale = 1.0
        sw.maximumZoomScale = 1.5
        sw.backgroundColor = Color.ace
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        sw.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        sw.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)
        return sw
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.itemSize = CGSize.init(width: kScreenWidth, height: kScreenHeight)
        lt.scrollDirection = .horizontal
        lt.sectionInset = .zero
        lt.minimumLineSpacing = 0
        lt.minimumInteritemSpacing = 0
        let cw = UICollectionView(frame: .zero, collectionViewLayout: lt)
        cw.isPagingEnabled = true
        cw.backgroundColor = Color.ace
        cw.delegate = self
        cw.dataSource = self
        cw.register(ReadCell.self, forCellWithReuseIdentifier: "ReadCell")
        return cw
    }()
    
    lazy var settingBar: ReadSettingBar = {
        let tr = ReadSettingBar()
        tr.delegate = self
        tr.backButton.addTarget(self, action: #selector(pressBack), for: .touchUpInside)
        let _ = tr.backgroundImage.addOnClickListener(target: self, action: #selector(settingTapAction))
        return tr
    }()

    
    @objc private func rightTapAction(){
        if isLoading { return }
        print(selectedRow)
        showWaitView(color: Color.Navigation)
        loadComic()
    }
    
    @objc private func settingTapAction() {
        isBarHidden = true
    }
    @objc private func tapAction(){
        isBarHidden = false
    }
    
    @objc private func doubleTapAction(){
        
    }
    
    @objc private func pressBack() {
        navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func showWaitView(color: UIColor) {
        super.showWaitView(color: color)
        isLoading = true
    }
    
    override func hideWaitView() {
        super.hideWaitView()
        isLoading = false
    }
    
}

extension ReadViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width: kScreenWidth, height: kScreenHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReadCell", for: indexPath) as! ReadCell
        
        cell.setImg(imgUrl: imgArray[indexPath.row], sData: gMetaModel.sdatas[indexPath.row], fileName: gMetaModel.title) { [weak self] (image, sData) in
            guard let weakSelf = self else { return }
            if weakSelf.canDownLoad {
                ImageUtils.saveImage(image: image, withFileName: self?.gMetaModel.title ?? "unfindname", withName: "\(sData.pageNumber).jpg")
                weakSelf.thumbDict[sData.pageNumber] = image
            }
            
        }
//        cell.setImg(imgUrl: imgArray[indexPath.row], sData: gMetaModel.sdatas[indexPath.row], fileName: gMetaModel.title)
//        if canDownLoad {
//            cell.imageRequestSuccess = {[weak self] (image,sData) in
//                
//                ImageUtils.saveImage(image: image, withFileName: self?.gMetaModel.title ?? "unfindname", withName: "\(sData.pageNumber).jpg")
//                self?.thumbDict[sData.pageNumber] = image
//            }
//        }
        return cell
    }
    

}

extension ReadViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isBarHidden == false { isBarHidden = true }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == backScrollView {
            return collectionView
        } else {
            return nil
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView {
            print(collectionView.contentOffset)
            selectedRow = Int(collectionView.contentOffset.x / kScreenWidth)
        }
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == backScrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.width * scrollView.zoomScale, height: scrollView.frame.height)
        }
    }
}

extension ReadViewController: ReadSettingBarDelegate {
    
    func thumbDidClick(index: Int) {
        isBarHidden = true
        collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        selectedRow = index
        
    }
    
    
}
