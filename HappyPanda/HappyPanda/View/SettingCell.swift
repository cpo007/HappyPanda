//
//  SettingCell.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/8/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var preferenceName: UILabel!
    
    @IBOutlet weak var preferenceSwitch: UISwitch!
    
    var valueDidChange:((_ value: String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
    }
    
    func getPreferenceData(preference: PreferenceModel) {
        
        preferenceName.text = preference.preferenceName
        
        switch preference.style {
        case 1 :
            preferenceSwitch.isHidden = false
            preferenceSwitch.isOn = preference.desc == "1"
        default:
            preferenceSwitch.isHidden = true
        }
        
    }

    @IBAction func switchDidClick(_ sender: UISwitch) {
        
        valueDidChange?(sender.isOn ? "1":"0")
    }
    
}
