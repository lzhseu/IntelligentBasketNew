//
//  LZHSearchController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/11/2.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

fileprivate let kLzhSearchTintColor = UIColor(r: 0.12, g: 0.74, b: 0.13, alpha: 1)
let kSectionColor = contentBgColor

protocol LZHSearchControllerDelegate: class {
    func lzhDidSearch()
    func lzhCancelSearch()
    func lzhBeginEdit()
}

class LZHSearchController: UISearchController {
    
    weak var lzhDelegate: LZHSearchControllerDelegate?
    
    // MARK: - 懒加载属性
    lazy var hasFindCancelBtn: Bool = {
        return false
    }()
    
    lazy var link: CADisplayLink = {
        CADisplayLink(target: self, selector: #selector(findCancel))
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - 相关设置
extension LZHSearchController {
    func setup() {
        searchBar.barTintColor = kSectionColor
        
        // 搜索框
        searchBar.barStyle = .default
        searchBar.tintColor = kLzhSearchTintColor
        searchBar.setBackgroundImage(contentBgColor.trans2Image(), for: .any, barMetrics: .default) //去除背景和上下两条线
        searchBar.placeholder = "搜索"
        
         
        if #available(iOS 13.0, *)  {
            setCancelBtnTitle(title: "取消")
        } else {
            searchBar.setValue("取消", forKey: "_cancelButtonText")
        }
        
        
        searchBar.delegate = self
    }
    
    
}


// MARK: - 适配 IOS13
extension LZHSearchController {
    
    /// 寻找搜索栏的取消按钮
    func findCancelBtn() -> UIButton? {
        for cc in self.searchBar.subviews {
            for zz in cc.subviews {
                for gg in zz.subviews {
                    if gg.isKind(of: UIButton.self) {
                        return gg as? UIButton
                    }
                }
            }
        }
        return nil
    }
    
    /// 设置取消按钮字样
    func setCancelBtnTitle(title: String) {
        guard let btn = findCancelBtn() else {
            return
        }
        
        btn.setTitle(title, for: .normal)
    }
 }




// MARK: - 事件监听函数
extension LZHSearchController {
    @objc private func findCancel() {
        guard let btn = findCancelBtn() else {
            return
        }

        //let btn = searchBar.value(forKey: "_cancelButton") as AnyObject
        if btn.isKind(of: NSClassFromString("UINavigationButton")!) {
            print("========================hhhhh")
            link.invalidate()
            link.remove(from: RunLoop.current, forMode: .common)
            hasFindCancelBtn = true
            //let cancel = btn as! UIButton
            btn.setTitle("取消", for: .normal)
            btn.setTitleColor(kLzhSearchTintColor, for: .normal)
            // cancel.setTitleColor(UIColor.orange, for: .highlighted)
        }
    }
}

// MARK: - UISearchBarDelegate
extension LZHSearchController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        lzhDelegate?.lzhBeginEdit()
        if !hasFindCancelBtn {
            link.add(to: RunLoop.current, forMode: .common)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        lzhDelegate?.lzhDidSearch()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        lzhDelegate?.lzhCancelSearch()
    }
    
}
