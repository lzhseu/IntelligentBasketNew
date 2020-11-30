//
//  BaseViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/18.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - 属性重写
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUI() {
        setNavigationBar(title: nil)
    }
    
    /// 设置导航栏样式
    func setNavigationBar(title: String?) {
        navigationItem.title = title
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = primaryColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    /// 设置导航栏标题
    func setNavigationBarTitle(title: String?) {
        navigationItem.title = title
    }
    
    /// 控件约束
    func makeConstraints() {
        
    }
    
    /// 控件正常的颜色
    func normalViewColor(view: UIView) {
        view.backgroundColor = primaryColor
    }
    
    /// 控件点击时的颜色
    func clickViewColor(view: UIView) {
        view.backgroundColor = primaryColor_0_8
    }
    
    /// 控件禁用时的颜色
    func disabledViewColor(view: UIView) {
        
    }
    
    /// 进入某一视图
    func pushViewController(viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /// 返回上一视图
    func popViewController(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    /// 返回指定视图
    func popViewController(viewController: UIViewController, animated: Bool) {
        navigationController?.popToViewController(viewController, animated: animated)
    }
    
    /// 返回根视图
    func popToRootViewController(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }
    // @objc     
    /// 获取导航栏高度
    func getNavigationBarH() -> CGFloat {
        return navigationController?.navigationBar.frame.height ?? 0
    }
    
}
