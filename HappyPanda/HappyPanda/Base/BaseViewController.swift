//
//  BaseViewController.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import SnapKit

let navigationItemLeftDistence :CGFloat = 0

class BaseViewController: UIViewController {
    var statusView:UIView?
    var navigationView:UIView?
    var titleView:UIView?
    var leftView:UIView?
    var rightView:UIView?
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var segment: UISegmentedControl?
    var viewDidAppearCount = 0
    var isWillDisappear = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isWillDisappear = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isWillDisappear = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewDidAppearCount > 1 {
            viewDidAppearCount = 0
        }
        viewDidAppearCount+=1
    }
    
    
    func showWaitView(color:UIColor){
        if indicator.superview == nil {
            indicator.color = color
            view.addSubview(self.indicator)
            indicator.snp.makeConstraints({ (make) in
                make.centerX.equalTo(view)
                make.centerY.equalTo(view)
            })
            indicator.startAnimating()
        }
        indicator.isHidden = false
    }
    
    func hideWaitView(){
        indicator.removeFromSuperview()
    }
    
    
    // MARK : - statusBar
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - navigationView
    func setUpNavigationView(){
        let navigationColor = Color.purple
        statusView = UIView()
        statusView?.backgroundColor = navigationColor
        view.addSubview(statusView!)
        
        statusView?.snp.makeConstraints { (make) in
            make.top.leading.width.equalTo(self.view)
            make.height.equalTo(self.topLayoutGuide.snp.height)
        }
        
        
        navigationView = UIView()
        navigationView?.backgroundColor = navigationColor
        view.addSubview(navigationView!)
        navigationView?.snp.makeConstraints({ (make) in
            make.top.equalTo(statusView!.snp.bottom)
            make.leading.width.equalTo(self.view)
            make.height.equalTo(44)
        })
    }
    
    func setNavTitleView(titleView:UIView){
        if navigationView == nil{
            setUpNavigationView()
        }
        self.titleView = titleView
        navigationView!.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.center.equalTo(self.navigationView!)
            make.width.equalTo(titleView.frame.width)
            make.height.equalTo(titleView.frame.height)
        }
    }
    
    func setNavTitle(title:String){
        if navigationView == nil{
            setUpNavigationView()
        }
        if let label = self.titleView as? UILabel {
            label.text = title
        } else {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 22)
            label.textAlignment = NSTextAlignment.center
            label.textColor = UIColor.white
            label.text = title
            navigationView!.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.center.height.equalTo(self.navigationView!)
                make.width.equalTo(self.navigationView!).offset(100)
            })
            self.titleView = label as UIView
        }
    }
    
    func setNavLeftView(leftView:UIView){
        if navigationView == nil{
            setUpNavigationView()
        }
        self.leftView?.removeFromSuperview()
        self.leftView = leftView
        navigationView!.addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.navigationView!)
            make.leading.equalTo(navigationItemLeftDistence)
            make.width.equalTo(leftView.frame.width)
            make.height.equalTo(leftView.frame.height)
        }
        
    }
    
    func setNavRightView(rightView:UIView){
        if navigationView == nil{
            setUpNavigationView()
        }
        self.rightView = rightView
        navigationView!.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.navigationView!)
            make.trailing.equalTo(self.navigationView!).offset(navigationItemLeftDistence)
            make.width.equalTo(rightView.frame.width)
            make.height.equalTo(rightView.frame.height)
        }
    }
    
    func setNavRightButton(title: String) -> UIButton{
        if navigationView == nil{
            setUpNavigationView()
        }
        
        let nextButton  = UIButton()
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextButton.setTitle(title, for: UIControlState.normal)
        nextButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        nextButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        nextButton.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: UILayoutConstraintAxis.horizontal)
        
        self.rightView = nextButton
        navigationView?.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.navigationView!)
            make.trailing.equalTo(self.navigationView!).offset(navigationItemLeftDistence)
        }
        return nextButton
    }
    
    func setNavRightButton(image: UIImage?) -> UIButton{
        if navigationView == nil{
            setUpNavigationView()
        }
        let nextButton  = UIButton()
        nextButton.setImage(image, for: UIControlState.normal)
        nextButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        nextButton.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: UILayoutConstraintAxis.horizontal)
        
        self.rightView = nextButton
        navigationView?.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.navigationView!)
            make.trailing.equalTo(self.navigationView!).offset(navigationItemLeftDistence)
        }
        return nextButton
    }
    
    func setNeedNavigationBar(title :String ,needBackButton:Bool) {
        if navigationView == nil{
            setUpNavigationView()
        }
        self.setNavTitle(title: title)
        if needBackButton {
            let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            let back = UIButton(type: UIButtonType.custom)
            back.setImage(R.image.ic_back(), for: UIControlState.normal)
            back.addTarget(self, action: #selector(BaseViewController.backAction(sender:)), for: UIControlEvents.touchUpInside)
            back.frame = frame
            self.setNavLeftView(leftView: back)
        }
    }
    
    func setNeedNavigationBarWithSegment(needBackButton:Bool, stringArray: [String]) {
        if navigationView == nil{
            setUpNavigationView()
        }
        if titleView != nil {
            titleView?.removeFromSuperview()
        }
        let segment = UISegmentedControl(items: stringArray)
        navigationView?.addSubview(segment)
        segment.selectedSegmentIndex = 0
        segment.tintColor = UIColor.white
        self.segment = segment
        
        segment.snp.makeConstraints { (make) in
            make.center.equalTo(navigationView!)
        }
        segment.addTarget(self, action: #selector(segmentDidChange(sender:)), for: UIControlEvents.valueChanged)
        
        if needBackButton {
            let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            let back = UIButton(type: UIButtonType.custom)
            back.setImage(R.image.ic_back(), for: UIControlState.normal)
            back.addTarget(self, action: #selector(BaseViewController.backAction(sender:)), for: UIControlEvents.touchUpInside)
            back.frame = frame
            self.setNavLeftView(leftView: back)
        }
    }
    
    @objc func segmentDidChange(sender: UISegmentedControl) {
        
    }
    
    @objc func backAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func configUI(){
        
    }
}
