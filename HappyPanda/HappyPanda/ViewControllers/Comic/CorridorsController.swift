//
//  CorridorsController.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import Kanna
import SwiftyJSON
import ViewDeck

class CorridorsController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gDataArray = [GDataModel]()
    var gMetaArray = [GMetaModel]()
    var page = 0
    var searchStr: String?
    var isSearchTag = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.uHead.beginRefreshing()
        view.backgroundColor = Color.ace
        tableView.backgroundColor = UIColor.clear

        NotificationCenter.default.addObserver(self, selector: #selector(configurationDone), name: NSNotification.Name.ConfigurationDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSearch(notification:)), name: NSNotification.Name.DidSearch, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSearchTag(notification:)), name: NSNotification.Name.TagDidSearch, object: nil)

    }
    
    override func configUI() {
        super.configUI()
        setNeedNavigationBar(title: "回廊", needBackButton: false)
        setSliderView()
        
        let topView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 44))
        
        let searchBtn = UIButton.init(type: UIButtonType.custom)
        searchBtn.setImage(R.image.icon_search_white(), for: UIControlState.normal)
        searchBtn.size = CGSize.init(width: 30, height: 30)
        searchBtn.addTarget(self, action: #selector(searchButtonDidClick), for: UIControlEvents.touchUpInside)
        
        let resetBtn = UIButton.init(type: UIButtonType.custom)
        resetBtn.setImage(R.image.icon_reset(), for: UIControlState.normal)
        resetBtn.addTarget(self, action: #selector(resetButtonDidClick), for: UIControlEvents.touchUpInside)
        
        setNavRightView(rightView: topView)
        topView.addSubview(searchBtn)
        topView.addSubview(resetBtn)
        
        searchBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.trailing.equalTo(topView).offset(-15)
        }
        
        resetBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.trailing.equalTo(searchBtn.snp.leading).offset(-15)
        }
        
        tableView.register(R.nib.comicDetailCell)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.uHead = URefreshHeader { [weak self] in
            self?.page = 0
            self?.requestEXMain(page: 0)
        }
        
        tableView.uFoot = URefreshAutoFooter { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.page+=1
            weakSelf.requestEXMain(page: weakSelf.page)
        }
        
        (tableView.uHead as! URefreshHeader).stateLabel.textColor = Color.White
        (tableView.uHead as! URefreshHeader).lastUpdatedTimeLabel.isHidden = true
        (tableView.uFoot as! URefreshAutoFooter).stateLabel.textColor = Color.White

    }
    
    private func setSliderView(){
        if viewDeckController?.rightViewController == nil {
            viewDeckController?.rightViewController = R.storyboard.main.searchController()!
            self.viewDeckController?.delegate = self

        }
    }
    
    private func requestEXMain(page: Int){
        
        var urlString = HPNeetWorking.baseUrl
        urlString.append("/?page=\(page)")
        
        if searchStr != nil {
            let str = "&f_search=" + searchStr!.replacingOccurrences(of: " ", with: "+")
            urlString.append(str)
            urlString.append("&f_apply=Apply+Filter")
        }
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        
        HPNeetWorking.shareTools.requestHtml(method: .post, urlString: urlString, completionHandler: { [weak self](html) in
            
            
            if let doc = try? HTML(html: html, encoding: .utf8) {
                
                var gMetaArr = [GMetaModel]()
                
                for table in doc.css("table") {
                    if table.className == "itg gltc"{
                        for node in table.css("tr") {
                            if node.content == "PublishedTitleUploader" { continue }
                            gMetaArr.append(HTMLUtils.getGMetaModel(node: node))
                        }
                    }
                }
                
                if page >= 1 {
                    self?.gMetaArray+=gMetaArr
                } else {
                    self?.gMetaArray=gMetaArr
                }
                
                self?.tableView.reloadData()
                page >= 1 ? self?.tableView.uFoot.endRefreshing() : self?.tableView.uHead.endRefreshing()

            } else {
                page >= 1 ? self?.tableView.uFoot.endRefreshing() : self?.tableView.uHead.endRefreshing()
                let vc = R.storyboard.main.configurationController()!
                vc.getPandaImage(data: html)
                self?.present(vc, animated: true, completion: nil)
            }
            
        }) { (error) in
            page >= 1 ? self.tableView.uFoot.endRefreshing() : self.tableView.uHead.endRefreshing()
        }
    }
    
    @objc private func configurationDone(){
        tableView.uHead.beginRefreshing()
    }
    
    @objc private func didSearch(notification:Notification) {
        self.viewDeckController?.closeSide(true)
        guard let detail = notification.object as? [String:Any] else { return }
        
        guard let search = detail["search"] as? String, let tags = detail["tags"] as? [String:String] else { return }
        if search.isEmpty { return }
        isSearchTag = false
        var searchStr = "&f_search=" + search.replacingOccurrences(of: " ", with: "+")
        
        var tagsStr = ""
        
        for (k,v) in tags {
            tagsStr.append("&")
            tagsStr.append(k)
            tagsStr.append("=")
            tagsStr.append(v)
        }
        
        let endStr = tagsStr + searchStr
        searchStr = endStr
        self.searchStr = searchStr
        tableView.uHead.beginRefreshing()
    }
    
    @objc private func didSearchTag(notification:Notification) {
        guard let tagStr = notification.object as? String else { return }
        isSearchTag = true
        self.searchStr = tagStr
        tableView.uHead.beginRefreshing()
        
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func searchButtonDidClick(){
        self.viewDeckController?.open(IIViewDeckSide.right, animated: true)
        if viewDeckController?.rightViewController is SearchController,isSearchTag {
            (viewDeckController?.rightViewController as! SearchController).searchStr = searchStr
        }
    }
    
    @objc private func resetButtonDidClick(){
        searchStr = nil
        tableView.uHead.beginRefreshing()
        if viewDeckController?.rightViewController is SearchController {
            (viewDeckController?.rightViewController as! SearchController).clear()
        }
    }
    
}


extension CorridorsController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gMetaArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.comicDetailCell, for: indexPath)!
        
        cell.loadData(gMetaModel: gMetaArray[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let model = gMetaArray[indexPath.row]
        let vc = R.storyboard.main.comicDetailController()!
        vc.gMetaModel = model
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CorridorsController: IIViewDeckControllerDelegate {
    
    func viewDeckController(_ viewDeckController: IIViewDeckController, willOpen side: IIViewDeckSide) -> Bool {
        
        if viewDeckController.rightViewController is SearchController,isSearchTag {
            (viewDeckController.rightViewController as! SearchController).searchStr = searchStr
        }
        return true
    }
    
}
