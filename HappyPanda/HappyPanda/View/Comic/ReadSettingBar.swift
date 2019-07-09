//
//  ReadSettingBar.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/26.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

protocol ReadSettingBarDelegate {
    func thumbDidClick(index: Int)
}

class ReadSettingBar: UIView {
    
    static let thumbHeight: CGFloat = kScreenHeight / 3
    static let thumbWidth: CGFloat = kScreenWidth / 2
    
    var delegate: ReadSettingBarDelegate?
    var thumbArray = [String]()
    
    lazy var backgroundImage: UIImageView = {
        let img = UIImageView.init(image: R.image.icon_readbar_background())
        return img
    }()
    
    lazy var thumbBackgroundView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.black
        view.alpha = 0.7
        return view
    }()

    lazy var backButton: UIButton = {
        let bn = UIButton(type: .custom)
        bn.setTitleColor(UIColor.white, for: UIControlState.normal)
        bn.cornerRadius = 5
        bn.borderWidth = 2
        bn.boardColor = Color.purple
        bn.setTitle("回到列表", for: UIControlState.normal)
        bn.setBackgroundImage(R.image.icon_backbtn_background(), for: UIControlState.normal)
        return bn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        addSubview(backgroundImage)
        
        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(backButton)
        
        backButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 200, height: 60))
            make.top.equalToSuperview().offset(140)
        }
        
        addSubview(thumbBackgroundView)
        thumbBackgroundView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: kScreenWidth, height: ReadSettingBar.thumbHeight))
        }
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(ReadSettingBar.thumbHeight - 20)
            make.width.equalTo(kScreenWidth - 20)
        }
        
    }
    
    func resetView(selectedRow: Int){
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath.init(row: selectedRow, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        
    }
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.itemSize = CGSize.init(width: ReadSettingBar.thumbWidth, height: ReadSettingBar.thumbHeight - 21)
        lt.scrollDirection = .horizontal
        lt.sectionInset = .zero
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 10
        let cw = UICollectionView(frame: .zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.clear
        cw.isPagingEnabled = false
        cw.delegate = self
        cw.dataSource = self
        cw.showsVerticalScrollIndicator = false
        cw.showsHorizontalScrollIndicator = false
        cw.register(ThumbCell.self, forCellWithReuseIdentifier: "ThumbCell")
        return cw
    }()

}


extension ReadSettingBar: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbCell", for: indexPath) as! ThumbCell
        
        cell.setImg(imgUrl: thumbArray[indexPath.row], pageNumber: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.thumbDidClick(index: indexPath.row)
    }
}
