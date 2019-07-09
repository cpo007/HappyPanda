//
//  SettingController.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/8/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

class SettingController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var userPreference: UserPreference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedNavigationBar(title: "设置", needBackButton: true)
        getUserPreference()
    }
    
    private func getUserPreference(){
        if let userPreference = SettingUtils.share.getUserPreferences() {
            self.userPreference = userPreference
            tableView.reloadData()
        }
    }
    
    override func configUI() {
        
        view.backgroundColor = Color.ace
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(R.nib.settingCell)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        
    }

    
    
}

extension SettingController: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userPreference?.listPreferences[section].listPreferenceName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userPreference?.listPreferences.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPreference?.listPreferences[section].preferences.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingCell, for: indexPath)!
        cell.getPreferenceData(preference: userPreference!.listPreferences[indexPath.section].preferences[indexPath.row])
        
        
        cell.valueDidChange = { value in
            let index = indexPath
            SettingUtils.share.setUserPreferences(index: index, value: value)
        }
        
        return cell
    }
}
