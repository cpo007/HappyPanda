//
//  TrajectoryController.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

class TrajectoryController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    
    var historys = [GMetaModel]()
    var collections = [GMetaModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func configUI() {
        setNeedNavigationBarWithSegment(needBackButton: false, stringArray: ["历史","收藏"])
        let rightBtn = setNavRightButton(title: "用户")
        rightBtn.addTarget(self, action: #selector(toSettingVC), for: UIControlEvents.touchUpInside)
        view.backgroundColor = Color.ace
        
        scrollView.isScrollEnabled = false
        
        tableView1.backgroundColor = UIColor.clear
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.register(R.nib.comicDetailCell)
        tableView1.separatorStyle = .none
        tableView1.tableFooterView = UIView()

        tableView2.backgroundColor = UIColor.clear
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.register(R.nib.comicDetailCell)
        tableView2.separatorStyle = .none
        tableView2.tableFooterView = UIView()
        
        
        tableView1.uHead = URefreshHeader { [weak self] in
            self?.requestHistory()
        }
        
        tableView2.uHead = URefreshHeader { [weak self] in
            self?.requestCollection()
        }
        
        (tableView1.uHead as! URefreshHeader).stateLabel.textColor = Color.White
        (tableView1.uHead as! URefreshHeader).lastUpdatedTimeLabel.isHidden = true
        
        (tableView2.uHead as! URefreshHeader).stateLabel.textColor = Color.White
        (tableView2.uHead as! URefreshHeader).lastUpdatedTimeLabel.isHidden = true
        
        tableView1.uHead.beginRefreshing()
        tableView2.uHead.beginRefreshing()
        
    }
    
    private func requestCollection(){
        do {
            tableView2.reloadData()
        } catch {
            debugPrint(error)
        }
        tableView2.uHead.endRefreshing()
    }
    
    private func requestHistory(){
        
        do {
            tableView1.reloadData()
        } catch {
            debugPrint(error)
        }
        tableView1.uHead.endRefreshing()
    }
    
    override func segmentDidChange(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        scrollView.setContentOffset(CGPoint.init(x: kScreenWidth * CGFloat(index), y: 0), animated: false)
        print(scrollView.contentSize)
    }
    
    @objc private func toSettingVC(){
        
        navigationController?.pushViewController(R.storyboard.main.settingController()!, animated: true)
        
    }
}

extension TrajectoryController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 101 {
            return historys.count
        } else {
            return collections.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 101 {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.comicDetailCell, for: indexPath)!
            let gMeta = historys[indexPath.row]
            cell.loadData(gMetaModel: gMeta)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.comicDetailCell, for: indexPath)!
            let gMeta = collections[indexPath.row]
            cell.loadData(gMetaModel: gMeta)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model: GMetaModel
        if tableView.tag == 101 {
            model = historys[indexPath.row]
        } else {
            model = collections[indexPath.row]
        }
        
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let vc = R.storyboard.main.comicDetailController()!
        vc.gMetaModel = model
        navigationController?.pushViewController(vc, animated: true)
    }
}
