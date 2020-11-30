//
//  RoleBaseViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit

private let NoBasketImageName = "ic_no_avaliable_basket"
private let NoProjectImageName = "ic_no_avaliable_project"
private let kImageViewWH: CGFloat = 64
let kNoBasketPageViewTag: Int = 11404
let kNoProjectPageViewTag: Int = 12404

class RoleBaseViewController: BaseViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = contentBgColor
    }
    
}

extension RoleBaseViewController{
    
    /// 加载没有吊篮数据页面
    func LoadNoBasketPage(){
        removeNoBasketPage()
        loadEmptyPage(title: "没有相关吊篮", image: NoBasketImageName, viewTag: kNoBasketPageViewTag)
    }
    
    func removeNoBasketPage() {
        removeEmptyPage(viewTag: kNoBasketPageViewTag)
    }
    
    /// 加载没有项目数据页面
    func loadNoProjectPage() {
        removeNoProjectPage()
        loadEmptyPage(title: "找不到相关项目", image: NoProjectImageName, viewTag: kNoProjectPageViewTag)
    }
    
    func removeNoProjectPage() {
        removeEmptyPage(viewTag: kNoProjectPageViewTag)
    }
    
    private func loadEmptyPage(title: String, image: String, viewTag: Int) {
        removeNoBasketPage() //load 之前最好先 remove 一下
        
        let imageView = CommonViewFactory.createImageView(image: image)
        let tipLabel = CommonViewFactory.createLabel(title: title, font: UIFont.systemFont(ofSize: 16), textColor: normalTitleColor)
        let bgView = UIView()
        bgView.backgroundColor = contentBgColor
        bgView.tag = viewTag
        
        view.addSubview(bgView)
        bgView.addSubview(imageView)
        bgView.addSubview(tipLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(90)
            make.width.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(kImageViewWH)
        }
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
        }
    }
    
    private func removeEmptyPage(viewTag: Int) {
        let pageView = view.viewWithTag(viewTag)
        pageView?.removeFromSuperview()
    }
}

