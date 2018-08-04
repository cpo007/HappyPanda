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
//    var sDataArray = [SDataModel]()
    var imgArray = [String]()
    var page = 0
    
    private var isBarHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.settingBar.alpha = self.isBarHidden ? 0 : 1
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        loadComic()
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
        
        view.addSubview(settingBar)
        settingBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func loadComic(){
        if imgArray.count < gMetaModel.sdatas.count {
            let sData = gMetaModel.sdatas[imgArray.count]
            let url = HPNeetWorking.sHead + "\(sData.page_token ?? "")/\(sData.galleryId ?? "")-\(sData.pageNumber)"
            
            HPNeetWorking.shareTools.requestHtml(method: .post, urlString: url, completionHandler: { [weak self](html) in
                self?.collectionView.uFoot.endRefreshing()
                if let doc = try? HTML(html: html, encoding: .utf8) {
                    for link in doc.css("img") {
                        if let path = link["src"] {
                            if !path.hasPrefix("https://"){
                                print(path)
                                self?.imgArray.append(path)
                                self?.collectionView.reloadData()
                            }
                        }
                    }
                }
                
            }) { (error) in
                
            }
            
        } else {
            
            page+=1
            loadComicDetailWeb(page: page)
        }
    }
    
    
    private func loadComicDetailWeb(page: Int?){
        
        guard let data = gMetaModel else { return }
        if gMetaModel.sdatas.count >= Int(data.filecount ?? "0") ?? 0 { return }
        
        var urlString = HPNeetWorking.gHead + "\(data.gid ?? 0)/\(data.token ?? "")/"
        
        if let p = page {
            urlString.append("/?p=\(p)")
        }
        
        print(urlString)
        HPNeetWorking.shareTools.requestHtml(method: .post, urlString: urlString, completionHandler: { [weak self](html) in
            self?.hideWaitView()
            if let doc = try? HTML(html: html, encoding: .utf8) {
                
                for div in doc.css("div"){
                    if div["id"] == "gdt"{
                        data.sdatas+=HTMLUtils.getSMetaArray(node: div)
                        self?.loadComic()
                    }
                }
            }
        }) { (error) in
            
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
        lt.sectionInset = .zero
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 10
        let cw = UICollectionView(frame: .zero, collectionViewLayout: lt)
        cw.isPagingEnabled = false
        cw.backgroundColor = Color.ace
        cw.delegate = self
        cw.dataSource = self
        cw.register(ReadCell.self, forCellWithReuseIdentifier: "ReadCell")
        cw.uFoot = URefreshAutoFooter { [weak self] in
            self?.loadComic()
        }
        
        (cw.uFoot as! URefreshAutoFooter).stateLabel.textColor = Color.White

        return cw
    }()
    
    lazy var settingBar: ReadSettingBar = {
        let tr = ReadSettingBar()
        tr.backButton.addTarget(self, action: #selector(pressBack), for: .touchUpInside)
        let _ = tr.addOnClickListener(target: self, action: #selector(settingTapAction))
        return tr
    }()

    
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
        cell.imgUrl = imgArray[indexPath.row]
        
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
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
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == backScrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.width * scrollView.zoomScale, height: scrollView.frame.height)
        }
    }
}
