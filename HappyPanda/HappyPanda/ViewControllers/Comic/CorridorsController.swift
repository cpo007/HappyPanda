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

class CorridorsController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var searchView: SearchView!
    
    var gDataArray = [GDataModel]()
    var gMetaArray = [GMetaModel]()
    var page = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        tableView.uHead.beginRefreshing()
        view.backgroundColor = Color.ace
        tableView.backgroundColor = UIColor.clear

        NotificationCenter.default.addObserver(self, selector: #selector(configurationDone), name: NSNotification.Name.ConfigurationDone, object: nil)
        
        
    }
    
    override func configUI() {
        super.configUI()
        setNeedNavigationBar(title: "回廊", needBackButton: false)
        let rightBtn = setNavRightButton(title: "搜索")
        rightBtn.addTarget(self, action: #selector(searchButtonDidClick), for: UIControlEvents.touchUpInside)
        
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
        (tableView.uFoot as! URefreshAutoFooter).stateLabel.textColor = Color.White
        
        

        searchView = SearchView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        view.addSubview(searchView)
        
        searchView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth, height: kScreenHeight))
            make.top.equalTo(view.bottom)
            make.centerX.equalTo(view)
        }
    }
    
    private func requestEXMain(page: Int){
        
        var urlString = HPNeetWorking.baseUrl
        if page > 0 {
            urlString.append("/?page=\(page)")
        }
        HPNeetWorking.shareTools.requestHtml(method: .post, urlString: urlString, completionHandler: { [weak self](html) in
            
            if let doc = try? HTML(html: html, encoding: .utf8) {
                
                var gMetaArr = [GMetaModel]()
                
                for link in doc.css("tr") {
                    guard let className = link.className, className.hasPrefix("gtr") else { continue }
                    gMetaArr.append(HTMLUtils.getGMetaModel(node: link))
                }
                
                if page >= 1 {
                    self?.gMetaArray+=gMetaArr
                } else {
                    self?.gMetaArray=gMetaArr
                }
                
                self?.tableView.reloadData()
                page >= 1 ? self?.tableView.uFoot.endRefreshing() : self?.tableView.uHead.endRefreshing()

                
                
//                var gMap = [GDataModel]()
//
//                for link in doc.css("a") {
//                    if let path = link["href"] {
//                        if path.hasPrefix(HPNeetWorking.gHead) {
//                            var a = path[HPNeetWorking.gHead.endIndex...]
//                            if a.hasSuffix("/") { a.removeLast()}
//                            let arr = a.components(separatedBy: "/")
//                            let model = GDataModel.init()
//                            model.galleryId = arr.first ?? ""
//                            model.galleryToken = arr.last ?? ""
//                            gMap.append(model)
//                        }
//                    }
//                }
//
//                if page >= 1 {
//                    self?.gDataArray+=gMap
//                } else {
//                    self?.gDataArray = gMap
//                }
//
//                self?.requestComicDetail(gDataArray: gMap, page: page)
                
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
    
    
    private func requestComicDetail(gDataArray:[GDataModel],page: Int){
        
        
        HPNeetWorking.shareTools.requestComicDetail(gDataArray: gDataArray, completionHandler: { (data) in
            
            page >= 1 ? self.tableView.uFoot.endRefreshing() : self.tableView.uHead.endRefreshing()
            if let jsonString = try? JSON.init(data: data) {
                if let data = [GMetaModel].deserialize(from: jsonString.description, designatedPath: "gmetadata") {
                    if page >= 1 {
                        self.gMetaArray+=(data as! [GMetaModel])
                    } else {
                        self.gMetaArray=(data as! [GMetaModel])
                    }
                    self.tableView.reloadData()
                }
            }
           
            
        }) { (error) in
            page >= 1 ? self.tableView.uFoot.endRefreshing() : self.tableView.uHead.endRefreshing()
        }
    }
    
    
    
    @objc private func configurationDone(){
        requestEXMain(page: 0)
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func searchButtonDidClick(){
        
        searchView.snp.updateConstraints { (make) in
            make.top.equalTo(view)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
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
